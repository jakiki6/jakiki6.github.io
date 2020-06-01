#!/bin/bash

# Packages
sudo apt install python3 curl jupp git cmatrix nasm gcc dosbox qemu-kvm python3-pip cifs tig gitk mksh

# Python
pip3 install PIL numpy networkx pandas matplotlib tensorflow

# Config
git config --global user.name "Jakob Kirsch"
git config --global user.email "jakob.kirsch@web.de"
git config --global core.editor jupp
git config --global pull.rebase true
echo "//server/jakob  /smb    cifs    user=jakob,password=kira        0       0" | sudo tee /etc/fstab > /dev/zero

# Data
cd
git clone https://github.com/jakiki6/bootOS.git
git clone https://github.com/jakiki6/jakiki6.github.io
sudo mount -a
mkdir Wurst7
cp /smb/Wurst7/.git Wurst7/
cd Wurst7
git reset --hard
cd


