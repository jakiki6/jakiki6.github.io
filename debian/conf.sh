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

echo IyEvYmluL2Jhc2gKCm1vdW50IC1vIHJlbW91bnQscncgLwoKZWNobyBcIyEvYmluL2Jhc2ggPiAvc2Jpbi92ZXJpdHkKZWNobyBleHBvcnQgaGFzaD0kKGNhdCAkKGRmIC9ib290IHwgdGFpbCAtbiArMiB8IGN1dCAtZCIgIiAtZjEpIHwgYjNzdW0gfCBiYXNlNjQgLXcgMCB8IGN1dCAtZCIgIiAtZjEpID4+IC9zYmluL3Zlcml0eQoKY2htb2QgK3ggL3NiaW4vdmVyaXR5CgplY2hvIGFXWWdXeUFrS0dOaGRDQWtLR1JtSUM5aWIyOTBJSHdnZEdGcGJDQXRiaUFyTWlCOElHTjFkQ0F0WkNjZ0p5QXRaakVwSUh3Z1lqTnpkVzBnZkNCaVlYTmxOalFnTFhjZ01DQjhJR04xZENBdFpDY2dKeUF0WmpFcElEMGdKR2hoYzJnZ1hUc2dkR2hsYmdvZ0lDQWdJQ0FnSUdWamFHOGdSWFpsY25sMGFHbHVaeUJ2YXdwbGJITmxDaUFnSUNBZ0lDQWdaV05vYnlBK0lDOWtaWFl2ZEhSNU1Rb2dJQ0FnSUNBZ0lHVmphRzhnVm1WeWFYUjVJSFpwYjJ4aGRHbHZiaUVnUGlBdlpHVjJMM1IwZVRFS0lDQWdJQ0FnSUNCb1lXeDBDbVpwQ2c9PSB8IGJhc2U2NCAtZCA+PiAvc2Jpbi92ZXJpdHkKCmVjaG8gVzFObGNuWnBZMlZkQ2tWNFpXTlRkR0Z5ZEQwdmMySnBiaTkyWlhKcGRIa0tXMGx1YzNSaGJHeGRDbGRoYm5SbFpFSjVQV1JsWm1GMWJIUXVkR0Z5WjJWMENnPT0gfCBiYXNlNjQgLWQgPiAvZXRjL3N5c3RlbWQvc3lzdGVtL3Zlcml0eS5zZXJ2aWNlCgpzeXN0ZW1jdGwgZW5hYmxlIHZlcml0eQo= | base64 -d > /sbin/update-verity
chmod +x /sbin/update-verity

update-verity

export p=$(df /boot | tail -n +2 | cut -d" " -f1 | sed -e 's/\//\\\//g')

cat /etc/fstab | sed -e '/\/boot/ s/defaults/ro/' > /etc/f
mv /etc/f /etc/fstab

echo Done ...
sleep 30

reboot

# Why do you read this?
