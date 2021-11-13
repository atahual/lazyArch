- [lazyArch](#lazyarch)
- [Usage](#usage)
- [Customizing](#customizing)
- [Contributing](#contributing)

# lazyArch
Arch for lazy people (like me)

First of all I have to thank [ChrisTitusTech](https://github.com/ChrisTitusTech) for his Livestreams on creating his script called [ArchTitus](https://github.com/ChrisTitusTech/ArchTitus).
Which inspired me to do my own.

This is my take on a full installation script of Arch Linux which will go from archiso to a fully usable install with minimal User input.

It is not intended for beginners!
So no fancy menu sorry.

You need know what values the script is asking for and there are no defaults or hints on what to type. (other than the install.example.conf maybe)

I try to be very modular and allow for easy customization and there are some examples on how those customization are done.

The script will install a Desktop Environment for you but those will not be configured in any way.
The choices currently available are:
 - KDE Plasma
 - Gnome
 - None

If choosing none xorg will still be installed and you can install anything you want after the installation is complete or use a custom script during installation.

# Usage

All you need to do is boot your Arch iso, install git, clone the project and run install.sh

```shell
pacman -Sy git
git clone https://github.com/atahual/lazyArch.git
cd lazyArch
./install.sh
```

That's basically it.
Easy right? And perfect for lazy people like us :D

If you want to save different configurations with customizations you might want package it in a zip or tar.gz on your local (or remote) http server and install it from there.

I personally use a zip like this:

```shell
pacman -Sy wget unzip
mkdir lazyArch
cd lazyArch
wget https://example.com/lazyArch.zip
unzip lazyArch.zip
chmod +x *.sh
./install.sh
```

# Customizing

You can *and should* customize the scipt to your liking so here are some on where to look.

**Make sure you save your files with _Line Feed_ only or the install will fail!**
**VS Code will show this in the bottom right corner as _LF_ (correct) or _CRLF_ (wich is Carriage Return + Line Feed and incorrect)**

In my new version you no longer have to touch the original files unless you want to use another kernel or custom partitions.

You can easily specify your pacman packages by putting a file containing the package names in ```pkglists/custom/```
I have some of my files in there to show you how you can use this.

Similarly for packages from the AUR you put the files into ```aurlists/custom/```

If any installed package or for your own configuration you need to run a script you can put it in ```scripts/custom```
These scripts will be run as your user so if you need root privileges run the command with sudo, during the installation it will not ask for a password to make it easy to use in a script. That will be changed at the end of the installation.
If you want to use a variable defined at the beginning of the installation (eg. username or desktop) you can source ```install.conf```.

After the installation is finished and you rebooted this repository will be in your home directory containing a ```install.conf``` file of your installation.

# Contributing

If you want a feature you can always ask for it or do it yourself and create a pull request
and if you find a bug open an issue with as much detail as you can give so I can reproduce it.
