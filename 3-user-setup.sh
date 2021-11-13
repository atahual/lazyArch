#!/bin/sh

. /"$HOME"/lazyArch/install.conf

# install AUR helper
cd "$HOME"
git clone "https://aur.archlinux.org/yay.git"
cd "$HOME"/yay
makepkg -si --noconfirm
cd "$HOME"
em -rf "$HOME"/yay


# install "essential" aur packages
yay -S --noconfirm - < "$HOME"/lazyArch/aurlists/base.list

case $desktop in
    "gnome") # gnome
        yay -S --noconfirm chrome-gnome-shell
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
