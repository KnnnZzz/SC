#!/bin/bash

# Install required packages for HAProxy, Pacemaker, Corosync, and PCS
sudo apt-get update
sudo apt-get install -y haproxy pacemaker corosync pcs

# Configure Corosync and HAProxy
sudo cp /vagrant/proxy/haproxy/corosync-haproxy.conf /etc/corosync/corosync.conf
sudo cp /vagrant/proxy/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg

# Enable and start necessary services
for service in corosync pacemaker pcsd; do
  sudo systemctl enable "$service"
  sudo systemctl start "$service"
done

# Define HAProxy as a resource in the cluster
sudo pcs resource create haproxy systemd:haproxy op monitor interval=1s

# Disable STONITH (fencing)
sudo pcs property set stonith-enabled=false

# Add a VirtualIP resource
sudo pcs resource create virtualip ocf:heartbeat:IPaddr2 ip=172.20.66.1 cidr_netmask=24 op monitor interval=1s

# Ensure HAProxy always runs with the VirtualIP resource
sudo pcs constraint colocation add haproxy with virtualip

# Configure migration threshold for both resources
for resource in haproxy virtualip; do
  sudo pcs resource update "$resource" meta migration-threshold=0
done

# Restart the cluster-related services
sudo systemctl restart corosync pacemaker pcsd
