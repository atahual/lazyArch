#!/bin/sh

printf "\nINSTALLING AUR SOFTWARE\n\n"

echo "CLONING: YAY"
cd "$HOME"
git clone "https://aur.archlinux.org/yay.git"
cd "$HOME"/yay
makepkg -si --noconfirm
cd "$HOME"

# Oh My zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME"/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# set zsh theme and plugins
sed -i "s/robbyrussell/avit/g" .zshrc
sed -i "s/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g" .zshrc

yay -S --noconfirm - < "$HOME"/lazyArch/aur.list

# xow for Xbox wireless adapter
sudo systemctl enable xow.service

# if nvidia, install GreenWithEnvy and enable overclocking
if lspci | grep -E "NVIDIA|GeForce"; then
    yay -S --noconfirm gwe
    sudo nvidia-xconfig --cool-bits=12
fi

printf "\nDone!\n\n"
exit
