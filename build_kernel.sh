#!/bin/bash
URL=https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.19.2.tar.xz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
KERNEL_VERSION=$(echo $DIR | sed 's/linux-//')

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


