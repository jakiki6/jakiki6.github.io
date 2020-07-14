#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Packages
apt install -y python3 curl jupp git cmatrix nasm gcc dosbox qemu-kvm python3-pip cifs-utils tig gitk mksh mumble firefox-esr linux-headers-$(uname -r) < /dev/null

# Python
pip3 install pillow numpy networkx matplotlib

# Config
git config --global user.name "Jakob Kirsch"
git config --global user.email "jakob.kirsch@web.de"
git config --global core.editor jupp
git config --global pull.rebase true
echo "//server/jakob  /smb    cifs    user=jakob,password=kira        0       0" >> /etc/fstab
sudo mkdir /smb
sudo chmod 777 /smb


# Data
cd
git clone https://github.com/jakiki6/bootOS.git
git clone https://github.com/jakiki6/jakiki6.github.io
sudo mount -a


# Create

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
~/.cargo/bin/cargo install b3sum
install -m 755 ~/.cargo/bin/* /bin/

if [ $(df /boot | tail -n +2 | awk '{ print $1 }') = $(df / | tail -n +2 | awk '{ print $1 }') ]; then
	echo Error, no boot partition!
	exit 1
fi

export p=$(df /boot | tail -n +2 | cut -d" " -f1)

mount -o remount,ro /boot || (echo Error; exit)

echo IyEvYmluL2Jhc2gKCmlmIFsgIiRFVUlEIiAtbmUgMCBdCiAgdGhlbiBlY2hvICJQbGVhc2UgcnVuIGFzIHJvb3QiCiAgZXhpdApmaQoKbW91bnQgLW8gcmVtb3VudCxydyAvCgplY2hvIFwjIS9iaW4vYmFzaCA+IC9zYmluL3Zlcml0eQplY2hvIGV4cG9ydCBoYXNoPSQoY2F0ICQoZGYgL2Jvb3QgfCB0YWlsIC1uICsyIHwgY3V0IC1kIiAiIC1mMSkgfCBiM3N1bSB8IGJhc2U2NCAtdyAwIHwgY3V0IC1kIiAiIC1mMSkgPj4gL3NiaW4vdmVyaXR5CgpjaG1vZCAreCAvc2Jpbi92ZXJpdHkKCmVjaG8gYVdZZ1d5QWlKRVZWU1VRaUlDMXVaU0F3SUYwS0lDQjBhR1Z1SUdWamFHOGdJbEJzWldGelpTQnlkVzRnWVhNZ2NtOXZkQ0lLSUNCbGVHbDBDbVpwQ2dwcFppQmJJQ1FvWTJGMElDUW9aR1lnTDJKdmIzUWdmQ0IwWVdsc0lDMXVJQ3N5SUh3Z1kzVjBJQzFrSnlBbklDMW1NU2tnZkNCaU0zTjFiU0I4SUdKaGMyVTJOQ0F0ZHlBd0lId2dZM1YwSUMxa0p5QW5JQzFtTVNrZ1BTQWthR0Z6YUNCZE95QjBhR1Z1Q2lBZ0lDQWdJQ0FnWldOb2J5QkZkbVZ5ZVhSb2FXNW5JRzlyQ21Wc2MyVUtJQ0FnSUNBZ0lDQmxZMmh2SUQ0Z0wyUmxkaTkwZEhreENpQWdJQ0FnSUNBZ1pXTm9ieUJXWlhKcGRIa2dkbWx2YkdGMGFXOXVJU0ErSUM5a1pYWXZkSFI1TVFvZ0lDQWdJQ0FnSUdoaGJIUUtabWtLIHwgYmFzZTY0IC1kID4+IC9zYmluL3Zlcml0eQoKZWNobyBXMU5sY25acFkyVmRDa1Y0WldOVGRHRnlkRDB2YzJKcGJpOTJaWEpwZEhrS1cwbHVjM1JoYkd4ZENsZGhiblJsWkVKNVBXUmxabUYxYkhRdWRHRnlaMlYwQ2c9PSB8IGJhc2U2NCAtZCA+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vdmVyaXR5LnNlcnZpY2UKCnN5c3RlbWN0bCBlbmFibGUgdmVyaXR5Cg== | base64 -d > /sbin/update-verity
chmod +x /sbin/update-verity

update-verity

export p=$(df /boot | tail -n +2 | cut -d" " -f1 | sed -e 's/\//\\\//g')

cat /etc/fstab | sed -e '/\/boot/ s/defaults/ro/' > /etc/f
mv /etc/f /etc/fstab

echo Done ...
sleep 30

reboot

# Why do you read this?
