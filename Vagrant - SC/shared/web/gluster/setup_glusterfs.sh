#!/bin/bash

# Install GlusterFS
sudo apt-get update && sudo apt-get install -y glusterfs-server

# Start and enable the service
sudo systemctl start glusterd
sudo systemctl enable glusterd

# Create the Folder where the GlusterFS volume will be mounted
sudo mkdir -p /raid1/cluster/www
sudo mkdir -p /raid1/cluster/sql

# Create the local file
sudo mkdir -p /cluster/www