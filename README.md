# pki-tools

Some of my scripts for working with TLS certificates with OpenSSL


Preface
-------
A couple of local conventions:

* I keep my tools and cert store in `/opt/pki/tls`, away from the
  system/package managed directories to avoid clobbering them with Chef
  or accidentally deleting them.
* I use filenames for certificates/requests/keys in the form of
  "`<fqdn>-<YYYYMMDD>-{cert,csr,key}.pem`" and that's how these scripts
  expect to output them.

Tools
-----

* `make-wannnet-csrkey.sh` - Generates a certificate request and key.
  Optionally adds subject alternative names (SANs) to the request.

  Examples for generating a cert request for www.example.com:

```
# Without a SAN
./make-wannnet-csrkey.sh www.example.com

# With SANs
./make-wannnet-csrkey.sh www.example.com m.example.com example.com
``` 

  If you're curious what this does, sample output from running
  `make-wannnet-csrkey.sh` can be found in the `make-wannnet-csrkey.output`
  file.
