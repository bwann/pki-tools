# pki-tools

Some of my scripts for working with TLS certificates with OpenSSL

* `make-wannnet-csrkey.sh` - Generates a certificate request and key.
  Optionally adds subject alternative names (SANs) to the request.

  Examples for generating a cert request for www.example.com:

```
# Without a SAN
./make-wannnet-csrkey.sh www.example.com

# With SANs
./make-wannnet-csrkey.sh www.example.com m.example.com example.com
``` 
