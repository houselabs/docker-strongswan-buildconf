## Usage
```bash
docker run -i -v /data/strongswan:/data \
  -e VPN_DOMAIN=abc.com \
  -e VPN_DNS=192.168.0.1 \
  -e VPN_SUBNET=192.168.1.0/24 \
  -e VPN_PSK=sdasdas \
  -e VPN_USERNAME=ohsc \
  -e VPN_PASSWORD=pppsssswwwddd \
  houselabs/strongswan-buildconf
```

Certs for client are generated in /data/strongswan/ssl
