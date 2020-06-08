#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Packages
apt install python3 curl jupp git cmatrix nasm gcc dosbox qemu-kvm python3-pip cifs tig gitk mksh mumble firefox

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

# Create

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
~/.cargo/bin/cargo install b3sum
install -m 755 ~/.cargo/bin/* /bin/

if ["df /boot | tail -n +2 | awk '{print $1}'" -e "df / | tail -n +2 | awk '{print $1}'"]; then
	echo Error, no boot partition!
	exit 1
fi

p = df /boot | tail -n +2 | awk '{print $1}'

mount -o remount,ro /boot || (echo Error; exit)

echo hash = $(b3sum $p) > /sbin/verity

chmod +x /sbin/verity

cat >> /sbin/verity <<EOF
if [ "$(b3sum $(df /boot | tail -n +2 | awk '{print $1}'))" -ne $hash]; then
	shutdown 0
fi
EOF

cat > /etc/systemd/system/verity.service <<EOF
[Service]
ExecStart=/sbin/verity
[Install]
WantedBy=default.target
EOF

systemctl enable verity

path = df /boot | tail -n +2 | awk '{print $1}' | sed -ie 's/\//\\\//g'

sed -ie '/^$path/ s/defaults/defaults,ro/' /etc/fstab

reboot

# Why do you read this?
