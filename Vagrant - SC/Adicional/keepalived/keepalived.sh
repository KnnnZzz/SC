#!/bin/bash

# Atualizar pacotes e instalar Keepalived
# sudo apt-get update
# sudo apt-get install -y keepalived

# Configurar o Keepalived
sudo tee /etc/keepalived/keepalived.conf <<EOF
vrrp_instance VI_1 {
    state BACKUP
    interface eth1
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 12345
    }
    virtual_ipaddress {
        192.168.66.110
    }
    track_script {
        chk_mariadb
    }
}

vrrp_script chk_mariadb {
    script "systemctl is-active mariadb"
    interval 2
    weight 2
}
EOF

# Iniciar e habilitar o Keepalived
sudo systemctl start keepalived
sudo systemctl enable keepalived