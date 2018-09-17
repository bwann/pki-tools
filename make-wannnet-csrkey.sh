#!/bin/bash
#
# Quick and dirty script to generate example.com certificate requests and keys
#
# First script argument is the fqdn hostname to use as the common name (CN) on
# the certificate, remaining arguments are added as subjectAltNames to the
# request.
#
# Example usage (no subject alternative name):
# ./make-wannnet-csrkey.sh  www.example.com
#   or
# Example with two subject alternative names:
# ./make-wannnet-csrkey.sh  www.example.com m.example.com example.com
#
# 
umask 077

if [ $# -eq 0 ] ; then
  echo $"Usage: `basename $0` hostname.fqdn [altname1 altname2 ...]"
  exit 0
fi

# Timestamp to use in filenames YYYMMDD
ts=$(date '+%Y%m%d')

# Values to feed into OpenSSL for the cert request
answer() {
  echo "US"               # C  Country
  echo "California"       # ST State/Providence
  echo "Fremont"          # L  Locality
  echo "example.com"      # O  Org name
  echo ""                 # OU Org unit
  echo "$1"               # CN Common name  (1st script argument)
  echo "pki@example.com"  #    E-mail address
  echo ""                 #    Challenge pass
  echo ""                 #    Optional company name
}

target=$1
sanlist=""
openssl_cnf='/opt/pki/CA/intermediate/openssl.cnf'
keyout="/opt/pki/tls/private/${target?}-${ts?}-key.pem"
csrout="/opt/pki/tls/csr/${target?}-${ts?}-csr.pem"

echo "*** Creating certificate with CN=${target?}"

# Process any subject alternative names.
# Take the first argument to the script as the main CN to put on the cert,
# take all remaining arguments and use them as subjectAltNames
if [ $# -gt 1 ]; then
  shift
  SANS="$@"

  # Build a comma-delimited list of DNS: names, but without any trailing comma
  LIST=""
  for i in ${SANS[*]}; do
    LIST="${LIST:+$LIST,}DNS:$i"
  done
  sanlist="subjectAltName=${LIST}"

  echo "*** Adding subject alternative names: ${LIST}"
fi

echo

touch ${keyout?} && chmod 400 ${keyout?} && chown root.root ${keyout?}

if [ -z "${sanlist?}" ]; then
  # We don't have any subjAltNames to deal with
  answer ${target?} | /usr/bin/openssl req -newkey rsa:2048 \
    -keyout "${keyout?}" -sha256 -nodes -days 365 \
    -out ${csrout?} \
    -config ${openssl_cnf?}
else
  # This calls -config passing in our standard openssl.cnf, then appending our 
  # formatted list of subjectAltNames as a phony extension section
  answer ${target?} | /usr/bin/openssl req -newkey rsa:2048 \
    -keyout "${keyout?}" -sha256 -nodes -days 365 \
    -out ${csrout?} \
    -reqexts SAN -extensions SAN \
    -config <(cat ${openssl_cnf} <(printf "[SAN]\n${sanlist?}"))
fi

echo
echo

if [ $? -ne 0 ]; then
  echo "*** error on ${target?}"
  exit 1
else
  echo "*** certificate request written to ${csrout?}"
fi
