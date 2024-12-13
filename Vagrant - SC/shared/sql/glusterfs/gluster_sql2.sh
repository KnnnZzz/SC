#!/bin/bash

# Atualizar pacotes e instalar GlusterFS
sudo apt-get install -y
sudo apt-get update -y  
sudo apt-get install glusterfs-client -y

# Criar as "pastas locais"
sudo mkdir -p /cluster/sql

sudo mount -t glusterfs 192.168.66.122:/storage/sql /cluster/sql

# Adicionar o ponto de montagem ao fstab para montagem automática na inicialização
echo "192.168.66.122:/storage/sql /cluster/sql glusterfs defaults,_netdev 0 0" | sudo tee -a /etc/fstab

#Rebuild ao boot.image
sudo update-initramfs -u