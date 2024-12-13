#!/bin/bash

# Atualizar pacotes e instalar nginx
sudo apt-get update
sudo apt-get install -y nginx

# Configurar o Nginx para servir a página da empresa
sudo mkdir -p /cluster/www
echo "<h1>Bem-vindo à empresa</h1>" | sudo tee /cluster/www/index.html

# Configurar o Nginx para usar o diretório /cluster/www
sudo tee /etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /cluster/www;
    index index.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Reiniciar o Nginx para aplicar as configurações
sudo systemctl restart nginx
sudo systemctl enable nginx
