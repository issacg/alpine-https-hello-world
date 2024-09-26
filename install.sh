#!/bin/sh

apk add nginx openssl

openssl req -x509 -nodes -days 3650 -subj "/CN=*" -addext "subjectAltName=DNS:*" -newkey rsa:2048 -keyout /etc/ssl/private/server.key -out /etc/ssl/certs/server.crt;

sed -i '/listen \[::\]:80 default_server;/a \
    listen 443 ssl http2 default_server;\
    listen [::]:443 ssl http2 default_server;\
    ssl_certificate /etc/ssl/certs/server.crt;\
    ssl_certificate_key /etc/ssl/private/server.key;' /etc/nginx/http.d/default.conf

exec nginx -g 'daemon off;'