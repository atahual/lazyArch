#!/bin/sh

# fancy greeting
echo "*                                **                  *     "  
echo "*                               *  *                 *     "  
echo "*                              *    *                *     "  
echo "*       ****   ******  *    *  *    *  * **   ****   * *** "  
echo "*           *      *   *    *  *    *   *    *    *  **   *"  
echo "*       *****     *    *    *  ******   *    *       *    *"  
echo "*      *    *    *     *   **  *    *   *    *       *    *"  
echo "*      *   **   *       *** *  *    *   *    *    *  *    *"  
echo "*****   *** *  ******       *  *    *   *     ****   *    *"  
echo "                       *    *                              "  
echo "                        ****                               " 
echo "Hello and Welcome my lazy friend."

timedatectl set-ntp true

# configure pacman for installation
sed -i 's/^#Para/Para/' /etc/pacman.conf # download go zoom

# gather user input

# load from install.conf if exists
if [ -f /root/lazyArch/install.conf ]
then
    . /root/lazyArch/install.conf
else
    echo "For the beginning please enter some data."

    # I don't always ask for the hostname because you could prepare a config
    # including hostname without knowing the drive name
    printf "Hostname: "
    read -r hostname
    printf "Root Password: "
    read -r pwroot
    printf "Username: "
    read -r username
    printf "User Password: "
    read -r pwuser
    printf "Keyboard Layout: "
    read -r keyboard
    printf "Keyboard Layout (X11): "
    read -r xkeyboard
    printf "Locale: "
    read -r locale
    printf "Timezone: "
    read -r timezone
fi

# ALWAYS ask for drive to format
# so configs could be portable
printf "\nNow we need to know where to Install our fancy Arch.\n"
echo "Here are the available block devices."
lsblk
echo "Please enter the target disk: (example /dev/sda)"
echo "IMPORTANT: please don't screw this up!"

printf "DISK: "
read -r DISK

# generate install.config for later use

cat >install.conf <<EOF
hostname=$hostname
pwroot=$pwroot
username=$username
pwuser=$pwuser
keyboard=$keyboard
xkeyboard=$xkeyboard
locale=$locale
timezone=$timezone
DISK=$DISK
EOF

echo "Great! We are almost ready."
printf "Please double check if everything is correct.\n\n"

cat install.conf

echo "CONTINUING WILL WIPE YOUR SELECTED DRIVE!!!"
printf "Are you sure you want to continue? (Y/N) "
read -r formatdisk

case $formatdisk in
    y|Y|yes|Yes|YES)
        pacman -Sy --noconfirm --needed gptfdisk
        # disk prep
        sgdisk -Z "${DISK}" # zap all on disk
        sgdisk -a 2048 -o "${DISK}" # new gpt disk 2048 alignment

        # create partitions
        sgdisk -n 1:0:+512M "${DISK}" # partition 1 (UEFI SYS), default start block, 512MB
        sgdisk -n 2:0:0     "${DISK}" # partition 2 (Root), default start, remaining

        # set partition types
        sgdisk -t 1:ef00 "${DISK}"
        sgdisk -t 2:8300 "${DISK}"

        # label partitions
        sgdisk -c 1:"UEFISYS" "${DISK}"
        sgdisk -c 2:"ROOT" "${DISK}"

        # make filesystems
        printf "\nCreating Filesystems...\n\n"

        case $DISK in
            nvme*)
                mkfs.vfat -F32 -n "UEFISYS" "${DISK}p1"
                mkfs.ext4 -L "ROOT" "${DISK}p2"
                ;;
            *)
                mkfs.vfat -F32 -n "UEFISYS" "${DISK}1"
                mkfs.ext4 -L "ROOT" "${DISK}2"
                ;;
        esac
        ;;
esac

# mount target
mount -L ROOT /mnt
mkdir -p /mnt/boot/efi
mount -t vfat -L UEFISYS /mnt/boot/

# base install
#pacstrap /mnt "$(awk '{print $1}' "$(pwd)"/base.list)" --noconfirm
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-lts linux-lts-headers linux-firmware dash curl zsh nano git sudo archlinux-keyring wget libnewt --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab

cp --recursive /root/lazyArch /mnt/root/
