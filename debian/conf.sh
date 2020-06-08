#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Packages
apt install python3 curl jupp git cmatrix nasm gcc dosbox qemu-kvm python3-pip cifs-utils tig gitk mksh mumble firefox-esr linux-headers-$(uname -r)

# Python
pip3 install PIL numpy networkx pandas matplotlib tensorflow

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

if [ "$(df /boot | tail -n +2 | awk '{ print $1 }')" = "$(df / | tail -n +2 | awk '{ print $1 }')" ]; then
	echo Error, no boot partition!
	exit 1
fi

export p=$(df /boot | tail -n +2 | awk '{ print $1 }')

mount -o remount,ro /boot || (echo Error; exit)

echo export hash=$(cat $p | b3sum) > /sbin/verity

chmod +x /sbin/verity

cat << EOF > /sbin/verity
if [ "$(cat $(df /boot | tail -n +2 | awk '{ print $1 }') | b3sum)" != "$hash"]; then
	echo 64 > /proc/sysrq-trigger
fi
EOF

cat <<EOF > /etc/systemd/system/verity.service
[Service]
ExecStart=/sbin/verity
[Install]
WantedBy=default.target
EOF

systemctl enable verity

export p=$(df /boot | tail -n +2 | awk '{ print $1 }' | sed -e 's/\//\\\//g')

cat /etc/fstab | sed -e '/^$p/ s/defaults/defaults,ro/' > /etc/f
mv /etc/f /etc/fstab

echo Done ...
sleep 30

reboot

# Why do you read this?
