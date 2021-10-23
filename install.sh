#!/bin/sh

## step 1: format disks and install base system components
sh 1-base-install.sh

## step 2: configure the system and make it bootable
arch-chroot /mnt /root/lazyArch/2-system-setup.sh

## step 3: install from aur and do user specific things
. /mnt/root/lazyArch/install.conf
arch-chroot /mnt /usr/bin/runuser -u "$username" -- /home/"$username"/lazyArch/3-user-setup.sh


## step 4: finalize setup
arch-chroot /mnt /root/lazyArch/4-post-setup.sh
