#!/bin/bash

set -e

openssl req -x509 -nodes -days 365 \
    -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}"

chmod 644 /etc/nginx/ssl/inception.crt
chmod 600 /etc/nginx/ssl/inception.key

exec nginx -g "daemon off;"