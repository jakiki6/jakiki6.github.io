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

if [ "$(df /boot | tail -n +2 | awk '{ print $1 }')" = "$(df / | tail -n +2 | awk '{ print $1 }')" ]; then
	echo Error, no boot partition!
	exit 1
fi

export p=$(df /boot | tail -n +2 | cut -d" " -f1)

mount -o remount,ro /boot || (echo Error; exit)

echo \#!/bin/bash > /sbin/verity
echo export hash=$(cat $p | b3sum | base64 -w 0 | cut -d" " -f1) >> /sbin/verity

chmod +x /sbin/verity

cat << EOF >> /sbin/verity

if [ "\$(cat \$(df /boot | tail -n +2 | cut -d' ' -f1) | b3sum | base64 -w 0 | cut -d' ' -f1)" = "\$hash" ]; then
	echo Everything ok
else
	echo > /dev/tty1
	echo Verity violation!
	echo 1 > /proc/sys/kernel/sysrq
	echo e > /proc/sysrq-trigger
fi
EOF

cat << EOF > /etc/systemd/system/verity.service
[Service]
ExecStart=/sbin/verity
[Install]
WantedBy=default.target
EOF

systemctl enable verity

export p=$(df /boot | tail -n +2 | cut -d" " -f1 | sed -e 's/\//\\\//g')

cat /etc/fstab | sed -e '/\/boot/ s/defaults/ro/' > /etc/f
mv /etc/f /etc/fstab

echo Done ...
sleep 30

reboot

# Why do you read this?
