#!/bin/bash

sudo mount -t glusterfs 192.168.66.121:/storage/www /cluster/www

# Adicionar o ponto de montagem ao fstab para montagem automática na inicialização
echo "192.168.66.121:/storage/www /cluster/www glusterfs defaults,_netdev 0 0" | sudo tee -a /etc/fstab
