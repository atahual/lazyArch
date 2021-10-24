#!/bin/sh

# get config
. /root/lazyArch/install.conf

# Add sudo no password rights
# this is just for the installation and will be changed later in the script
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

# configure pacman
sed -i 's/^#Para/Para/' /etc/pacman.conf # download go zoom
sed -i "s/^#Color/Color\nILoveCandy/" /etc/pacman.conf # lookin fancy
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm

# MAKEPKG conf
nc=$(nproc)
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'"$nc"'"/g' /etc/makepkg.conf
sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$nc"' -z -)/g' /etc/makepkg.conf

# root password
echo "Changing password for root"
#passwd
echo "root:$pwroot" | chpasswd

# create user and ask for password
useradd -m -G users,wheel -s /bin/zsh "$username"
echo "Changing password for $username"
#passwd "$username"
echo "$username:$pwuser" | chpasswd

mkdir -p /home/$username/lazyArch/
cp --recursive /root/lazyArch/* /home/$username/lazyArch/

# set timezone
ln -sf /usr/share/zoneinfo/"$timezone" /etc/localtime
hwclock --systohc

# set and gen locale
if [ "$locale" != "en_US" ]
then
    sed -i "s/^#$locale.UTF-8 UTF-8/$locale.UTF-8 UTF-8/" /etc/locale.gen
fi
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

## post base install

# Graphics Drivers find and install
if lspci | grep -E "VGA|3D" | grep -E "NVIDIA|GeForce"; then
    pacman -S nvidia-dkms nvidia-settings nvidia-utils lib32-nvidia-utils vulkan-icd-loader lib32-vulkan-icd-loader --noconfirm --needed
elif lspci | grep -E "VGA|3D" | grep -E "Radeon"; then
    pacman -S xf86-video-amdgpu --noconfirm --needed
elif lspci | grep -E "VGA|3D" | grep -E "Integrated Graphics Controller|Intel"; then
    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
elif lspci | grep -E "VGA|3D" | grep -E "VMware"; then
    pacman -S virtualbox-guest-utils --noconfirm --needed
    systemctl enable vboxservice.service
fi

# install defined packages

pacman -S --noconfirm --needed - < /root/lazyArch/pkg.list
