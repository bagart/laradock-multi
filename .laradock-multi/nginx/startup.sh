#!/bin/bash

if [ ! -f /etc/nginx/ssl/default.crt ]; then
    openssl genrsa -out "/etc/nginx/ssl/default.key" 2048
    openssl req -new -key "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.csr" -subj "/CN=default/O=default/C=UK"
    openssl x509 -req -days 365 -in "/etc/nginx/ssl/default.csr" -signkey "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.crt"
fi

if [[ -f /etc/nginx/ssl/default.crt ]]; then
    for CERT_NAME in $(echo ${CERT_NAMES} | tr "," "\n")
    do
        if [[ ! -f /etc/nginx/ssl/${CERT_NAME}.crt ]]; then
            cp /etc/nginx/ssl/default.crt /etc/nginx/ssl/${CERT_NAME}.crt
            cp /etc/nginx/ssl/default.key /etc/nginx/ssl/${CERT_NAME}.key
        fi
    done
fi

# Start crond in background
crond -l 2 -b

# Start nginx in foreground
nginx
