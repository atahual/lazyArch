#!/bin/sh

. /"$HOME"/lazyArch/install.conf

# some pakages to install that are specific to the installed Desktop
# and I consider personal customization
# for that reason I put them in a custom script

case $desktop in
    "plasma") # plasma
        yay -S --noconfirm albert-bin
        ;;
    "gnome") # gnome
        # nothing to do yet
        ;;
    "mate") # mate
        yay -S --noconfirm brisk-menu albert-bin
        ;;
esac