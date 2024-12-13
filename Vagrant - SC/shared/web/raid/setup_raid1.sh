#!/bin/bash

# Atualizar pacotes e instalar mdadm
sudo apt-get update
sudo apt-get install -y mdadm

# Verificar se os dispositivos estão disponíveis
if [ ! -b /dev/sdc ] || [ ! -b /dev/sdd ]; then
    echo "Erro: Dispositivos /dev/sdc e /dev/sdd não encontrados. Abortando."
    exit 1
fi

# Criar o dispositivo RAID 1
sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdc /dev/sdd -R

# Verificar se o RAID foi criado com sucesso
if [ $? -ne 0 ]; then
    echo "Erro ao criar o RAID. Verifique os dispositivos."
    exit 1
fi

# Criar o sistema de arquivos no dispositivo RAID
sudo mkfs.ext4 /dev/md0

# Montar o dispositivo RAID
sudo mkdir -p /raid1
sudo mount /dev/md0 /raid1

# Verificar a montagem
if mount | grep "/dev/md0"; then
    echo "RAID montado com sucesso."
else
    echo "Erro ao montar o RAID."
    exit 1
fi

# Adicionar a configuração ao fstab para montagem automática
if ! grep -q "/dev/md0" /etc/fstab; then
    echo '/dev/md0 /raid1 ext4 defaults 0 0' | sudo tee -a /etc/fstab
fi

# Exibir o estado do RAID
sudo mdadm --detail /dev/md0
