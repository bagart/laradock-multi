#!/bin/bash
echo prepare SSL certificate for: ${CERT_DOMAIN_RULE}

#todo wildcards
#certbot certonly --manual --preferred-challenges dns --server https://acme-v02.api.letsencrypt.org/directory --manual-public-ip-logging-ok -d "$DOMAINS"

letsencrypt certonly --webroot -w /var/www/letsencrypt -d "${CERT_DOMAIN_RULE}" --agree-tos --email "${CERT_DOMAIN_EMAIL}" --non-interactive --text

if [[ -d /etc/letsencrypt/archive/ ]]; then
  cd /etc/letsencrypt/archive/
  echo '============ SUCCESS: SSL certificates created: ============'
  ls
  find * -type d -exec cp '/etc/letsencrypt/archive/{}/cert1.pem'    '/var/certs/{}.crt' \;
  find * -type d -exec cp '/etc/letsencrypt/archive/{}/privkey1.pem' '/var/certs/{}.key' \;
else
  echo '============ ERROR: No one certificate created ============='
fi

# not important improvement: 1st run nginx before certbot
for CERT_NAME in $(echo ${CERT_NAMES} | tr "," "\n")
do
  if [[ ! -f /etc/nginx/ssl/${CERT_NAME}.crt && -f /etc/nginx/ssl/default.crt ]]; then
    cp /etc/nginx/ssl/default.crt /etc/nginx/ssl/${CERT_NAME}.crt
    cp /etc/nginx/ssl/default.key /etc/nginx/ssl/${CERT_NAME}.key
  fi
done

echo   '============ STAT: exist certificates ======================'
ls /var/certs/ | grep crt
