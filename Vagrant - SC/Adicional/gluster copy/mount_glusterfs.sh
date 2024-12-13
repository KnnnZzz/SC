#!/bin/bash

# Mount the GlusterFS volume using the virtual IP
sudo mount -t glusterfs 192.168.66.120:/storage /cluster/www

# Add the mount point to /etc/fstab for automatic mounting at boot
echo "192.168.66.120:/storage /cluster/www glusterfs defaults,_netdev 0 0" | sudo tee -a /etc/fstab
