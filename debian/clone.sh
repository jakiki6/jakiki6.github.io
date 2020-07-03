#!/bin/bash

if [ "$EUID" != "0" ]; then
        echo Please run this with root
        exit 1
fi

if [ "$1" = "" ]; then
        echo Invalid path
        exit 1
fi

echo Test for existing device
head -c 512 $1 > /dev/zero

echo Creating partition table
(
echo o
echo n
echo
echo
echo
echo
echo w
) | fdisk $1

export device=$(losetup --show -fP $1 | tr -d '\n')
export partition=$(echo $(echo -n $device)p1)

if [ "$partition" = "" ]; then
        echo Error
        exit 2
fi

echo Formatting
mkfs.ext4 $partition

echo Mounting
mount $partition /mnt

echo Copying data
umask 022
rsync --links -rv --exclude=/mnt --exclude=$1 --exclude=/dev --exclude=/proc --exclude=/sys --exclude=/tmp --exclude=/media --exclude=/run / /mnt/

for v in dev proc sys tmp media run; do
        mkdir /mnt/$v
        mount --bind /$v /mnt/$v
done

echo Installing grub
chroot /mnt /sbin/grub-install --recheck --no-floppy --root-directory=/ $device
chroot /mnt /sbin/update-grub

echo Unmounting
for v in dev proc sys tmp media run; do
        umount /mnt/$v
done
sync
umount /mnt

echo Done
