#!/bin/bash

# Atualizar pacotes e instalar GlusterFS
sudo apt-get update && sudo apt-get install -y glusterfs-server

# Iniciar o serviço GlusterFS
sudo systemctl start glusterd
sudo systemctl enable glusterd

# Create the Folder where the GlusterFS volume will be mounted
sudo mkdir -p /raid1/cluster/www
sudo mkdir -p /raid1/cluster/sql

# Crias as "pastas locais"
sudo mkdir -p /cluster/www