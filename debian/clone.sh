#!/bin/bash

export FS="ext4"
export MNTPATH="/mnt"

if [ "$EUID" != "0" ]; then
        echo Please run this with root
        exit 1
fi

if [ "$1" = "" ]; then
        echo Invalid path
        exit 1
fi

echo Test for existing device
head -c 512 $1 > /dev/zero || (
	echo "Error" && exit
)

export device=$(losetup --show -fP $1 | tr -d '\n')

echo Wiping drive
dd if=/dev/zero of=$device

echo Creating partition table
(
echo o
echo n
echo
echo
echo
echo
echo w
) | fdisk $device

export partition=$(echo $(echo -n $device)p1)

if [ "$partition" = "" ]; then
        echo Error
        exit 2
fi

echo Formatting
mkfs.$FS $partition
partition_id=$(blkid -o value -s UUID $partition)

echo Mounting
mount $partition $MNTPATH

echo Copying data
umask 022
rsync --links -rv --exclude=$MNTPATH --exclude=$1 --exclude=/dev --exclude=/proc --exclude=/sys --exclude=/media --exclude=/run / $MNTPATH/

for v in dev proc sys media run; do
        mkdir $MNTPATH/$v
        mount --bind /$v $MNTPATH/$v
done

echo Writing new fstab
(
echo "# <file system> <mount point>   <type>  <options>       <dump>  <pass>"
echo -e "UUID=$partition_id \t$FS\tdefaults\t0\t1"
) > $MNTPATH/etc/fstab

echo Installing grub
chroot $MNTPATH /sbin/grub-install --recheck --no-floppy --root-directory=/ $device
chroot $MNTPATH /sbin/update-grub

echo Unmounting
umount -A --recursive $MNTPATH
sync

echo Done
