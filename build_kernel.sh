#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"

URL=https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.3.5.tar.xz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
KERNEL_VERSION=$(echo $DIR | sed 's/linux-//')
set -e

cd /usr/src

wget $URL

tar -xvf $TAR

cd $DIR

cp /boot/config-tucana .config

sed -i 's/EXTRAVERSION\ =/EXTRAVERSION\ =\ -tucana/' Makefile
make olddefconfig
make -j16

mkdir -p ../linux-tucana/boot
mkdir -p ../linux-tucana/usr

make INSTALL_MOD_PATH=../linux-tucana/usr modules_install

sudo cp arch/x86/boot/bzImage ../linux-tucana/boot/vmlinuz-$KERNEL_VERSION-tucana
sudo cp .config ../linux-tucana/boot/config-tucana
sudo rm -r block certs/ crypto/ Documentation/ drivers/ fs/ init/ ipc/ kernel/ lib/ LICENSES/ mm/ MAINTAINERS  modules.* Module.symvers net/ samples/ security/ sound/ usr/ virt/ vmlinux*
cd ../linux-tucana
echo "cd /boot" > postinst
echo "mkinitramfs $KERNEL_VERSION-tucana" >> postinst
echo "grub-mkconfig -o /boot/grub/grub.cfg" >> postinst

mkdir -p ../linux-tucana-headers/usr/src
cd ..
sudo cp -rpv $DIR linux-tucana-headers/usr/src

# Package
cd /usr/src
mv linux-tucana /pkgs
mv linux-tucana-headers /pkgs
echo "" > /pkgs/linux-tucana/depend
echo "linux-tucana rsync" > /pkgs/linux-tucana-headers/depend
cd /pkgs
tar -cvzpf linux-tucana.tar.xz linux-tucana
tar -cvzpf linux-tucana-headers.tar.xz linux-tucana-headers

cp linux-tucana.tar.xz /finished
cp linux-tucana-headers.tar.xz /finished
