#!/bin/bash

# Variables
VIRTUAL_IP=192.168.66.120
GLUSTER_VOLUME=storage
PEER1=192.168.66.121
PEER2=192.168.66.122
MOUNT_POINT=/cluster/www

# Ensure the GlusterFS service is running
sudo systemctl start glusterd
sudo systemctl enable glusterd

# Add peers to the cluster
sudo gluster peer probe $PEER1
sudo gluster peer probe $PEER2

# Check peer status
sudo gluster peer status

# Create the volume (if not already created)
sudo gluster volume create $GLUSTER_VOLUME replica 2 transport tcp $PEER1:/raid1 $PEER2:/raid1 force

# Start the volume
sudo gluster volume start $GLUSTER_VOLUME

# Create the mount point
sudo mkdir -p $MOUNT_POINT
sudo chmod 777 $MOUNT_POINT

# Mount the volume using the virtual IP
sudo mount -t glusterfs $VIRTUAL_IP:/$GLUSTER_VOLUME $MOUNT_POINT

# Add the mount to /etc/fstab for persistence
echo "$VIRTUAL_IP:/$GLUSTER_VOLUME $MOUNT_POINT glusterfs defaults,_netdev 0 0" | sudo tee -a /etc/fstab
