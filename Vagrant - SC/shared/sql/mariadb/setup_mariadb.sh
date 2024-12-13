#!/bin/bash

# Install MariaDB, Pacemaker, Corosync, and Pcs
echo "Installing MariaDB, Pacemaker, Corosync, and Pcs..."
sudo apt-get update
sudo apt-get install mariadb-server pacemaker corosync pcs -y

# Define variables
MARIADB_CONFIG_FILE="/vagrant/sql/mariadb/50-server.cnf"
COROSYNC_CONFIG_FILE="/vagrant/sql/mariadb/corosync-sql.conf"
VIRTUAL_IP="192.168.66.110"
VIRTUAL_NETMASK="24"
MARIADB_RESOURCE="mariadb"
VIRTUALIP_RESOURCE="virtualip"

sudo cp $MARIADB_CONFIG_FILE /etc/mysql/mariadb.conf.d/50-server.cnf
# Check if MariaDB is already initialized
if [ "$(ls -A /cluster/sql)" ]; then
    sleep 5
else
    sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/cluster/sql
    sudo chmod -R 777 /cluster/sql
fi

# Copy Corosync configuration file and start clustering services
echo "Setting up Corosync..."
if [ -f "$COROSYNC_CONFIG_FILE" ]; then
    sudo cp "$COROSYNC_CONFIG_FILE" /etc/corosync/corosync.conf
else
    echo "Corosync configuration file not found. Exiting."
    exit 1
fi

sudo systemctl enable --now corosync pacemaker pcsd

# Create the MariaDB resource in the cluster
echo "Configuring cluster resources..."
# sudo pcs cluster start --all
sudo pcs resource create "$MARIADB_RESOURCE" systemd:mariadb op monitor interval=1s

# Disable STONITH (only for testing purposes; use STONITH in production)
sudo pcs property set stonith-enabled=false

# Create a virtual IP resource for failover
sudo pcs resource create "$VIRTUALIP_RESOURCE" ocf:heartbeat:IPaddr2 ip="$VIRTUAL_IP" cidr_netmask="$VIRTUAL_NETMASK" op monitor interval=1s

# Configure colocation constraints
sudo pcs constraint colocation add "$MARIADB_RESOURCE" with "$VIRTUALIP_RESOURCE" INFINITY --force

# Set migration threshold for resources
sudo pcs resource update "$MARIADB_RESOURCE" meta migration-threshold=0
sudo pcs resource update "$VIRTUALIP_RESOURCE" meta migration-threshold=0

# Restart clustering services
echo "Restarting clustering services..."
sudo systemctl restart corosync pacemaker pcsd

# Validate the cluster
echo "Validating cluster resources..."
sudo pcs status

echo "High availability setup complete. MariaDB is now configured with a virtual IP: $VIRTUAL_IP"
