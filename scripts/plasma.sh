#!/bin/sh

# enable sddm
systemctl enable sddm.service

# apply breeze theme (good default for plasma)
cat >/etc/sddm.conf <<EOF
[Theme]
Current=breeze
EOF
