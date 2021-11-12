#!/bin/sh

# install AUR helper
cd "$HOME"
git clone "https://aur.archlinux.org/yay.git"
cd "$HOME"/yay
makepkg -si --noconfirm
cd "$HOME"


# install "essential" aur packages
yay -S --noconfirm - < "$HOME"/lazyArch/aurlists/base.list

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
