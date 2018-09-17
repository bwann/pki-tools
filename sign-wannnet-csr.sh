#!/bin/bash
#
# Signs certificate requests with the wann.net CA root cert
#
# Usage: $0 /path/to/csr.pem
# Outputs signed cert to newcerts/ and /etc/pki/tls/certs
#

# Example usage:
# /sign-wannnet-csr.sh ../tls/certs/firecracker.wann.net-20180629-csr.pem

umask 077

root_dir='/opt/pki/CA'
openssl_cnf="${root_dir?}/openssl.cnf"
ca_outdir="${root_dir?}/newcerts"

if [ $# -eq 0 ]; then
  echo $"Usage: `basename $0` csr-file.csr"
  exit 0
fi

certname=$(basename $1 -csr.pem)

# We know where our CA cert and key are from the openssl.cnf file
/usr/bin/openssl ca -config "${openssl_cnf}" \
  -extensions server_cert \
  -days 720 -notext -md sha256 \
  -in $1 \
  -out ${ca_outdir?}/${certname}-cert.pem

echo
echo

if [ $? -ne 0 ]; then
  echo "*** Couldn't sign cert for ${certname}"
  exit 1
fi

# Convienience step to copy new cert with our other ones
if [ -f "${ca_outdir}/${certname}-cert.pem" ]; then
  cp ${ca_outdir}/${certname}-cert.pem /opt/pki/tls/certs/
fi
