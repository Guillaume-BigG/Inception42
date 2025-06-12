#!/bin/bash

set -e

# Generate self-signed TLS certificate using DOMAIN_NAME from env
openssl req -x509 -nodes -days 365 \
    -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}"

# Secure certificate permissions
chmod 644 /etc/nginx/ssl/inception.crt
chmod 600 /etc/nginx/ssl/inception.key

# Start NGINX in foreground
exec nginx -g "daemon off;"