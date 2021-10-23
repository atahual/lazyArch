#!/bin/sh

## step 1: format disks and install base system components
sh 1-base-install.sh

## step 2: configure the system and make it bootable
arch-chroot /mnt /root/lazyArch/2-system-setup.sh