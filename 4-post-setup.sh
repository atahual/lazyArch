#!/bin/sh

. /root/lazyArch/install.conf

# delete repo in root home since we have it in the users home directory
rm -rf /root/lazyArch

# Lets make it safe again
# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers


printf "\n\n
+------------------------------------------------------------------+
| You've done did it! Now it's time to reboot into your Arch (btw) |
|                                                                  |
| A copy this repository is located in your home direcotry.        |
| There you will find your install.conf for this installation.     |
+------------------------------------------------------------------+
\n\n\n"
