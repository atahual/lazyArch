#!/bin/sh

# enable lightdm
systemctl enable lightdm.service

# set slick-greeter as default
sed -i 's|#greeter-session=.*|greeter-session=lightdm-slick-greeter|g' /etc/lightdm/lightdm.conf

# set a background image for slick-greeter
cat > /etc/lightdm/slick-greeter.conf << EOF
[Greeter]
background=/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Cold-no-logo.png
EOF
