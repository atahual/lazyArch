#!/bin/sh

. /root/lazyArch/install.conf

# This prevents a "too many files" error in Visual Studio Code
echo fs.inotify.max_user_watches=524288 | tee /etc/sysctl.d/40-max-user-watches.conf && sysctl --system

# Enable SDDM and apply theme
systemctl enable sddm.service

cat >/etc/sddm.conf <<EOF
[Theme]
Current=breeze
EOF

# Enable bluetooth
printf "\nEnabling bluetooth daemon and setting it to auto-start\n"

sed -i 's|#AutoEnable=false|AutoEnable=true|g' /etc/bluetooth/main.conf
systemctl enable bluetooth.service

# Enable services for network and printing
systemctl enable cups.service
ntpd -qg
systemctl enable ntpd.service
systemctl enable NetworkManager.service

# set keyboard layout for Xserver
cat > /etc/X11/xorg.conf.d/00-keyboard.conf << EOF
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "$xkeyboard"
        Option "XkbModel" "pc104"
EndSection
EOF

# Lets make it safe again
# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers


printf "\n\n
+------------------------------------------------------------------+
| You've done did it! Now it's time ro reboot into your Arch (btw) |
+------------------------------------------------------------------+
\n\n\n"
