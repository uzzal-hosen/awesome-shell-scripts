#!/bin/bash

read -p "Enter the server name: " server_name

# Generate OpenSSL certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=US/ST=State/L=City/O=Organization/CN=${server_name}"

# Update Nginx configuration
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80;
    listen [::]:80;

    server_name ${server_name};

    location / {
        return 301 https://\$host\$request_uri;
    }
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name ${server_name};

    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    location / {
        # Configuration for your virtual server
        # Add your specific server configuration here
    }
}
EOF

# Restart Nginx
service nginx restart
