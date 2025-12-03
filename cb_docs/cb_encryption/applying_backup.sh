#!/bin/bash

lsblk

user=$(logname)

if ! command -v partclone &>/dev/null; then
    echo "Installing partclone..."
    sudo apt-get update && sudo apt-get install -y partclone
fi

read -rp "Enter the name of the disk (e.g. sdb, sdc ...): " disk_type
umount /dev/${disk_type}1
umount /dev/${disk_type}2
umount /dev/${disk_type}3

read -rp "Enter the path where the partition backups reside (such as /home/$user/Desktop/BACKUP_ENC): " backup_path
read -rp "Enter the existing passphrase for the backup image: " existing_pass
echo "You entered: $backup_path"

sgdisk --load-backup=$backup_path/sdb-partition-table.bak /dev/${disk_type}

echo YES | cryptsetup luksHeaderRestore /dev/${disk_type}1 --header-backup-file $backup_path/luks-header-sdb1.backup

echo $existing_pass | cryptsetup open /dev/${disk_type}1 Rob

partclone.ext4 -C -r -s $backup_path/Rob4_sdb1.img -o /dev/mapper/Rob
partclone.ext4 -C -r -s $backup_path/Rob4_sdb2.img -o /dev/${disk_type}2
partclone.fat32 -C -r -s $backup_path/Rob4_sdb3.img -o /dev/${disk_type}3

mount /dev/mapper/Rob /mnt

cp enc_disk_setup.sh /mnt/home/conbotics/

umount /dev/mapper/Rob

cryptsetup close Rob

cryptsetup luksDump /dev/${disk_type}1
