- [lazyArch](#lazyarch)
- [Usage](#usage)
- [Customizing](#customizing)
    - [1-base-install.sh](#1-base-installsh)
    - [2-system-setup.sh](#2-system-setupsh)
    - [pkg.list](#pkglist)
    - [3-user-setup.sh](#3-user-setupsh)
    - [aur.list](#aurlist)
    - [4-post-setup.sh](#4-post-setupsh)

# lazyArch
Arch for lazy people (like me)

First of all I have to thank [ChrisTitusTech](https://github.com/ChrisTitusTech) for his Livestreams on creating his script called [ArchTitus](https://github.com/ChrisTitusTech/ArchTitus).
Which inspired me to do my own.

This is my take on a full installation script of Arch Linux which will go from archiso to a fully usable install with minimal User input.

It is not intended for beginners!
So no fancy menu sorry.

You need know what values the script is asking for and there are no defaults or hints on what to type. (other than the install.example.conf maybe)

Although everyone can run this you will end up with a System how I personally like it.

Including but not limited to following Features:

* KDE Desktop
* zsh Shell
* oh my zsh with some plugins
* Gaming ready (Steam, Lutris, and more)

So it is best used by foking the Project and personalizing it.

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

# Customizing

You can *and should* customize the scipt to your liking so here are some on where to look.

**Make sure you save your files with _Line Feed_ only or the install will fail!**
**VS Code will show this in the bottom right corner as _LF_ (correct) or _CRLF_ (wich is Carriage Return + Line Feed and incorrect)**

### 1-base-install.sh
At the bottom of this file you can change your partitioning and what kernel you want to install

### 2-system-setup.sh
**This gets executed in `chroot` as user root.**
Most things in here are done automatically but you can search for this `# configure bootloader` to configure your bootloader and entries. If you change the kernel you will have to change the entries.

### pkg.list
This file is used in the previous script and is just a list of all packages that will be install from the Arch Repositories.

### 3-user-setup.sh
**This gets executed in `chroot` as your defined User**
The only "automatic" thing done here is installing Packages from the AUR.
If you don't want anything from the AUR remove `yay -S --noconfirm - < "$HOME"/lazyArch/aur.list`
Everything else is what I want for my User so go ahead and do what you want in here.

### aur.list
This is the list of Packages installed from the Arch User Repository.

### 4-post-setup.sh
This will enable  Services if you installed some Packages that need that and do some final configuration.
