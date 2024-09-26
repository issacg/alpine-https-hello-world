#!/bin/sh

apk add nginx openssl

openssl req -x509 -nodes -days 3650 -subj "/CN=*" -addext "subjectAltName=DNS:*" -newkey rsa:2048 -keyout /etc/ssl/private/server.key -out /etc/ssl/certs/server.crt;

sed -i '/listen \[::\]:80 default_server;/a \
    listen 443 ssl default_server;\
    listen [::]:443 ssl default_server;\
    ssl_certificate /etc/ssl/certs/server.crt;\
    ssl_certificate_key /etc/ssl/private/server.key;\
access_log /dev/stdout main; # Redirect access logs to stdout\
error_log /dev/stderr; # Redirect error logs to stderr' /etc/nginx/http.d/default.conf

sed -i 's/^[[:space:]]*return 404;/        root \/var\/www\/localhost\/htdocs;/' /etc/nginx/http.d/default.conf

echo "<h1>Hello world!</h1>" > /var/www/localhost/htdocs/index.html

exec nginx -g 'daemon off;'