#!/bin/bash

# based on https://gist.github.com/hadilq/a491ca53076f38201a8aa48a0c6afef5
DISK=/dev/sda
parted "${DISK}" -- mklabel gpt
# EFI partition
parted "${DISK}" -- mkpart ESP fat32 1MB 512MB
parted "${DISK}" -- set 1 esp on # 1 is because the EFI is the first partition we created on this disk
# Format the EFI partition
mkfs.vfat -n BOOT "${DISK}1"

# ROOT partition
parted /dev/sda -- mkpart primary 512MB 100%
# cryptsetup
cryptsetup --verify-passphrase -v luksFormat "${DISK}2"
cryptsetup open "${DISK}2" luksdev
mkfs.btrfs /dev/mapper/luksdev

# Then create subvolumes
mkdir -p /mnt/
mount -t btrfs /dev/mapper/luksdev /mnt/

# We first create the subvolumes outlined above:
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/log
umount /mnt/btrfs_root

# Mount the directories
mount -o subvol=root,compress=zstd,noatime /dev/mapper/luksdev /mnt
mkdir /mnt/home
mount -o subvol=home,compress=zstd,noatime /dev/mapper/luksdev /mnt/home
mkdir /mnt/nix
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/luksdev /mnt/nix
mkdir -p /mnt/var/log
mount -o subvol=log,compress=zstd,noatime /dev/mapper/luksdev /mnt/var/log
# mount the boot partition
mkdir /mnt/boot
mount "$DISK"1 /mnt/boot
mkdir /mnt/boot/efi

# Nix generate default config
nixos-generate-config --root /mnt
nixos-install

