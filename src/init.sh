#!/bin/bash
OUT="/data"
SSL="$OUT/ssl"
if [ ! -d "$OUT" ]; then
    echo "$OUT is not mounted"
    exit -1
fi
if [ ! -d "$SSL" ]; then
    mkdir $SSL
fi

cp -r /etc/strongswan.* $OUT
cp -r /etc/ipsec.* $OUT
cp -r /usr/local/share/buildconf/* $SSL
sed -i "s#VPN_SUBNET#${VPN_SUBNET}#g" $OUT/ipsec.conf
sed -i "s#VPN_DOMAIN#${VPN_DOMAIN}#g" $OUT/ipsec.conf
sed -i "s#VPN_PSK#${VPN_PSK}#g" $OUT/ipsec.secrets
sed -i "s#VPN_USERNAME#${VPN_USERNAME}#g" $OUT/ipsec.secrets
sed -i "s#VPN_PASSWORD#${VPN_PASSWORD}#g" $OUT/ipsec.secrets
sed -i "s#VPN_DNS#${VPN_DNS}#g" $OUT/strongswan.d/charon.conf

# gen ca key and cert
ipsec pki --gen --outform pem > $OUT/ipsec.d/private/ca.pem
ipsec pki --self --in $OUT/ipsec.d/private/ca.pem --dn "C=CN, O=ING, CN=StrongSwan CA" --ca --lifetime 3650 --outform pem > $OUT/ipsec.d/cacerts/ca.cert.pem
# gen server key and cert
ipsec pki --gen --outform pem > $OUT/ipsec.d/private/server.pem  
ipsec pki --pub --in $OUT/ipsec.d/private/server.pem | ipsec pki --issue --lifetime 1200 --cacert $OUT/ipsec.d/cacerts/ca.cert.pem \
    --cakey $OUT/ipsec.d/private/ca.pem --dn "C=CN, O=ING, CN=${VPN_DOMAIN}" \
    --san="${VPN_DOMAIN}" --flag serverAuth --flag ikeIntermediate \
    --outform pem > $OUT/ipsec.d/certs/server.cert.pem
# gen client key and cert
ipsec pki --gen --outform pem > $OUT/ipsec.d/private/client.pem
ipsec pki --pub --in $OUT/ipsec.d/private/client.pem | ipsec pki --issue --cacert $OUT/ipsec.d/cacerts/ca.cert.pem \
    --cakey $OUT/ipsec.d/private/ca.pem --dn "C=CN, O=ING, CN=client.${VPN_DOMAIN}" \
    --san="client.${VPN_DOMAIN}" \
    --outform pem > $OUT/ipsec.d/certs/client.cert.pem

openssl pkcs12 -export -inkey $OUT/ipsec.d/private/client.pem -in $OUT/ipsec.d/certs/client.cert.pem -name "client.${VPN_DOMAIN}"\
         -certfile $OUT/ipsec.d/cacerts/ca.cert.pem -caname "StrongSwan CA"  -out $SSL/client.cert.p12

cp $OUT/ipsec.d/cacerts/ca.cert.pem $SSL/ca.cer
cp $OUT/ipsec.d/certs/server.cert.pem $SSL/server.cer
