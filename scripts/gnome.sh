#!/bin/sh

# enable gdm
systemctl enable gdm.service

# Prevent GNOME Software from downloading updates
gsettings set org.gnome.software download-updates false
