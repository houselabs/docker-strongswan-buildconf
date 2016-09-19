[![](https://images.microbadger.com/badges/version/houselabs/strongswan-buildconf.svg)](https://microbadger.com/images/houselabs/strongswan-buildconf "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/houselabs/strongswan-buildconf.svg)](https://microbadger.com/images/houselabs/strongswan-buildconf "Get your own image badge on microbadger.com") 

## Usage
```bash
docker run -i -v /data/strongswan:/data \
  -e VPN_DOMAIN=abc.com \
  -e VPN_DNS=192.168.0.1 \
  -e VPN_SUBNET=192.168.1.0/24 \
  -e VPN_PSK=sdasdas \
  -e VPN_USERNAME=ohsc \
  -e VPN_PASSWORD=pppsssswwwddd \
  -e VPN_P12_PASSWORD=lock \
  houselabs/strongswan-buildconf
```

Certs and mobileconfig for client are generated in /data/strongswan/ssl
