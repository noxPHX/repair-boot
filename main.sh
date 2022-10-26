#!/usr/bin/env bash

set -e # Stop the script on errors
set -u # Unset variables are an error

# Check the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

sudo mount /dev/root/Root /mnt
sudo mount /dev/root/Var /mnt/var
sudo mount /dev/root/Log /mnt/var/log
sudo mount /dev/root/Temp /mnt/tmp
sudo mount /dev/nvme0n1p1 /mnt/boot/efi
for i in dev dev/pts proc sys run; do sudo mount -B /$i /mnt/$i; done
sudo chroot /mnt
apt install --reinstall linux-image-generic linux-headers-generic
update-initramfs -c -k all
exit
sudo bootctl --path=/mnt/boot/efi install
for i in dev/pts dev proc sys run; do sudo umount /mnt/$i; done
sudo umount /mnt/boot/efi /mnt/tmp /mnt/var/log /mnt/var /mnt
