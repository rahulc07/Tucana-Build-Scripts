#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"

URL=https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.0.9.tar.xz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
KERNEL_VERSION=$(echo $DIR | sed 's/linux-//')
PACKAGE=linux-tucana-surface
set -e

# This is a custom kernel with patches for surface devices, this will not be pushed to the mainline repo
cd /usr/src

git clone https://github.com/linux-surface/linux-surface.git


wget $URL

tar -xvf $TAR


cd $DIR

cp /boot/config-tucana .config

sed -i 's/EXTRAVERSION\ =/EXTRAVERSION\ =\ -tucana-surface/' Makefile
make olddefconfig
for i in $(readlink -f  /usr/src/linux-surface/patches/6\.0/*); do
	patch -p1 < $i
done

make -j20

mkdir -p ../$PACKAGE/boot
mkdir -p ../$PACKAGE/usr

make INSTALL_MOD_PATH=../$PACKAGE/usr modules_install

sudo cp arch/x86/boot/bzImage ../$PACKAGE/boot/vmlinuz-$KERNEL_VERSION-tucana-surface
sudo cp .config ../$PACKAGE/boot/config-tucana
sudo rm -r block certs/ crypto/ Documentation/ drivers/ fs/ init/ ipc/ kernel/ lib/ LICENSES/ mm/ MAINTAINERS  modules.* Module.symvers net/ samples/ security/ sound/ usr/ virt/ vmlinux*
cd ../$PACKAGE
echo "cd /boot" > postinst
echo "mkinitramfs $KERNEL_VERSION-tucana-surface" >> postinst
echo "grub-mkconfig -o /boot/grub/grub.cfg" >> postinst

mkdir -p ../$PACKAGE-headers/usr/src
cd ..
sudo cp -rpv $DIR $PACKAGE-headers/usr/src

# Package
cd /usr/src
mv $PACKAGE /pkgs
mv $PACKAGE-headers /pkgs
echo "" > /pkgs/$PACKAGE/depend
echo "$PACKAGE rsync" > /pkgs/$PACKAGE-headers/depend
cd /pkgs
tar -cvzpf $PACKAGE.tar.xz $PACKAGE
tar -cvzpf $PACKAGE-headers.tar.xz $PACKAGE-headers

cp $PACKAGE.tar.xz /finished
cp $PACKAGE-headers.tar.xz /finished
