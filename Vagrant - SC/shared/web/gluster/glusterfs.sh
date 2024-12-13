#!/bin/bash

# Variáveis de configuração
DIRECTORY=/raid1/cluster
GLUSTER_VOLUME=storage
PEER1=192.168.66.121
PEER2=192.168.66.122

# Adicionar servidores ao cluster
sudo gluster peer probe 192.168.66.122

# Criar o volume GlusterFS
sudo gluster volume create storage replica 2 transport tcp 192.168.66.121:/raid1/cluster 192.168.66.122:/raid1/cluster force
sudo gluster volume start $GLUSTER_VOLUME

sudo mount -t glusterfs 192.168.66.122:/storage/www /cluster/www

echo "192.168.66.122:/storage/www /cluster/www glusterfs defaults,_netdev 0 0" | sudo tee -a /etc/fstab


