#!/bin/sh

# xow for Xbox wireless adapter
sudo systemctl enable xow.service

# if nvidia, install GreenWithEnvy and enable overclocking
if lspci | grep -E "NVIDIA|GeForce"; then
    yay -S --noconfirm gwe
    sudo nvidia-xconfig --cool-bits=12
fi
