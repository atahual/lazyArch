#!/bin/sh

# get config
. /root/lazyArch/install.conf

# configure pacman
sed -i 's/^#Para/Para/' /etc/pacman.conf # download go zoom
sed -i "s/^#Color/Color\nILoveCandy/" /etc/pacman.conf # lookin fancy
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm

# get the last user input out of the way
# root password
echo "Changing password for root"
passwd
# create user and ask for password
useradd -m -G users,wheel -s /bin/zsh "$username"
echo "Changing password for $username"
passwd "$username"

# set timezone
ln -sf /usr/share/zoneinfo/"$timezone" /etc/localtime
hwclock --systohc

# set and gen locale
sed -i "s/^#$locale.UTF-8 UTF-8/$locale.UTF-8 UTF-8/" /etc/locale.gen
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen # I personally always want en_US installed
locale-gen
echo "LANG=$locale.UTF-8" > /etc/locale.conf
echo "KEYMAP=$keyboard" > /etc/vconsole.conf

# set hostname
echo "$hostname" > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $hostname
EOF

# install and enable networkmanager
pacman -S networkmanager --noconfirm
systemctl enable NetworkManager

# get cpu vendor
case "$(cat /proc/cpuinfo | grep "vendor_id")" in
    *AMD*) 
        cpu="amd"
        ;;
    *Intel*)
        cpu="intel"
        ;;
esac

pacman -Sy "$cpu"-ucode --noconfirm

mkinitcpio -P

# install systemd-boot bootloader
bootctl install

# configure bootloader
mkdir -p /boot/loader/entries

cat > /boot/loader/loader.conf << EOF
default         arch.conf
timeout         0
conmsole-mode   max
editor          no
EOF

# lets get some entries
# PROC will be changed after ucode installation
cat > /boot/loader/entries/arch.conf << EOF
title   Arch Linux
linux /vmlinuz-linux-zen
initrd  /$cpu-ucode.img
initrd  /initramfs-linux-zen.img  
options root=LABEL=ROOT rw libahci.ignore_sss=1 quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log_level=3
EOF

cat > /boot/loader/entries/arch-lts.conf << EOF
title   Arch Linux LTS
linux /vmlinuz-linux-lts
initrd  /$cpu-ucode.img
initrd  /initramfs-linux-lts.img  
options root=LABEL=ROOT rw libahci.ignore_sss=1 quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log_level=3
EOF
