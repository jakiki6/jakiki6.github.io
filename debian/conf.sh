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

echo IyEvYmluL2Jhc2gKCmVjaG8gXCMhL2Jpbi9iYXNoID4gL3NiaW4vdmVyaXR5CmVjaG8gZXhwb3J0IGhhc2g9JChjYXQgJChkZiAvYm9vdCB8IHRhaWwgLW4gKzIgfCBjdXQgLWQiICIgLWYxKSB8IGIzc3VtIHwgYmFzZTY0IC13IDAgfCBjdXQgLWQiICIgLWYxKSA+PiAvc2Jpbi92ZXJpdHkKCmNobW9kICt4IC9zYmluL3Zlcml0eQoKZWNobyBhV1lnV3lBa0tHTmhkQ0FrS0dSbUlDOWliMjkwSUh3Z2RHRnBiQ0F0YmlBck1pQjhJR04xZENBdFpDY2dKeUF0WmpFcElId2dZak56ZFcwZ2ZDQmlZWE5sTmpRZ0xYY2dNQ0I4SUdOMWRDQXRaQ2NnSnlBdFpqRXBJRDBnSkdoaGMyZ2dYVHNnZEdobGJnb2dJQ0FnSUNBZ0lHVmphRzhnUlhabGNubDBhR2x1WnlCdmF3cGxiSE5sQ2lBZ0lDQWdJQ0FnWldOb2J5QStJQzlrWlhZdmRIUjVNUW9nSUNBZ0lDQWdJR1ZqYUc4Z1ZtVnlhWFI1SUhacGIyeGhkR2x2YmlFZ1BpQXZaR1YyTDNSMGVURUtJQ0FnSUNBZ0lDQm9ZV3gwQ21acENnPT0gfCBiYXNlNjQgLWQgPj4gL3NiaW4vdmVyaXR5CgplY2hvIFcxTmxjblpwWTJWZENrVjRaV05UZEdGeWREMHZjMkpwYmk5MlpYSnBkSGtLVzBsdWMzUmhiR3hkQ2xkaGJuUmxaRUo1UFdSbFptRjFiSFF1ZEdGeVoyVjBDZz09IHwgYmFzZTY0IC1kID4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS92ZXJpdHkuc2VydmljZQoKc3lzdGVtY3RsIGVuYWJsZSB2ZXJpdHkK | base64 -d > /sbin/update-verity
chmod +x /sbin/update-verity

update-verity

export p=$(df /boot | tail -n +2 | cut -d" " -f1 | sed -e 's/\//\\\//g')

cat /etc/fstab | sed -e '/\/boot/ s/defaults/ro/' > /etc/f
mv /etc/f /etc/fstab

echo Done ...
sleep 30

reboot

# Why do you read this?
