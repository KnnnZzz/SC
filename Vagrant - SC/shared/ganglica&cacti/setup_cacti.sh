#!/bin/bash

# Atualizar pacotes e instalar Cacti
sudo apt-get update
sudo apt-get install -y cacti

# Configurar o Cacti para ser acessível via HTTPS
sudo tee /etc/nginx/sites-available/cacti <<EOF
server {
    listen 443 ssl;
    server_name _;

    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

    root /usr/share/cacti/site;
    index index.php;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
    }
}
EOF

# Ativar a configuração do Nginx para o Cacti
sudo ln -s /etc/nginx/sites-available/cacti /etc/nginx/sites-enabled/
sudo systemctl restart nginx
