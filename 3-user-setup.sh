#!/bin/sh

. /"$HOME"/lazyArch/install.conf

# install AUR helper
cd "$HOME"
git clone "https://aur.archlinux.org/yay.git"
cd "$HOME"/yay
makepkg -si --noconfirm
cd "$HOME"
rm -rf "$HOME"/yay


# install "essential" aur packages
yay -S --noconfirm - < "$HOME"/lazyArch/aurlists/base.list

case $desktop in
    "plasma") # plasma
        yay -S --noconfirm kde-cdemu-manager
        ;;
    "gnome") # gnome
        yay -S --noconfirm chrome-gnome-shell gcdemu
        ;;
    "mate") # mate
        yay -S --noconfirm gcdemu
        ;;
esac

# install custom aur packages
for aurlist in "$HOME"/lazyArch/aurlists/custom/*
do
    yay -S --noconfirm - < "$aurlist"
done

#run custom scripts
for customscript in "$HOME"/lazyArch/scripts/custom/*
do
    sh "$customscript"
done

exit
