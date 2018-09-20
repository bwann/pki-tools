# pki-tools

Some of my scripts for working with TLS certificates with OpenSSL


Preface
-------
A couple of local conventions. These are easy enough to change to fit
your needs, just so you know what to look for and expect.

* I keep my tools and cert store in `/opt/pki/tls`, away from the
  system/package managed directories to avoid clobbering them with Chef
  or accidentally deleting them.

```
/opt/pki/
/opt/pki/CA/         # Root CA files
  |- certs
  |- crl
  |- newcerts
  |- private
  |- intermediate/   # Intermediate CA files
     |- certs
     |- crl
     |- newcerts
     |- private
/opt/pki/tls/        # My cert/key/request store for distribution
  |- certs
  |- csr
  |- private
```

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

* `sign-wannnet-csr.sh` - Signs a certificate request with your CA,
  adding "server" extensions from `openssl.cnf`.

  Signing example:
```
./sign-wannnet-csr.sh ../tls/csr/example-20180915-csr.pem
```

  Example output is found in `sign-wannnet-csr.output`.


TODO: add scripts for requesting and signing user-level certs
