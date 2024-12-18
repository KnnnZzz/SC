#!/bin/bash

# Atualizar pacotes e instalar HAproxy
sudo apt-get update
sudo apt-get install -y haproxy

# Configurar o HAproxy para balanceamento de carga
sudo tee /etc/haproxy/haproxy.cfg <<EOF
# Global settings
global
    log /dev/log local0
    log /dev/log local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

defaults
    log global
    option httplog
    option dontlognull
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms
    errorfile 400 /etc/haproxy/errors/400.http
    errorfile 403 /etc/haproxy/errors/403.http
    errorfile 408 /etc/haproxy/errors/408.http
    errorfile 500 /etc/haproxy/errors/500.http
    errorfile 502 /etc/haproxy/errors/502.http
    errorfile 503 /etc/haproxy/errors/503.http
    errorfile 504 /etc/haproxy/errors/504.http
    
frontend http_front
    bind *:80
    default_backend http_back

backend http_back
    balance roundrobin
    server web1 192.168.66.121:80 check
    server web2 192.168.66.122:80 check
EOF

# Reiniciar o HAproxy para aplicar as configurações
sudo systemctl restart haproxy
