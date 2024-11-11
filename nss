#!/bin/bash


set -e
PKG_VER=3.106
URL=https://archive.mozilla.org/pub/security/nss/releases/NSS_$(sed 's/\./\_/g' <<< $PKG_VER)_RTM/src/nss-$PKG_VER.tar.gz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
PACKAGE=$(echo $DIR | sed 's|-[^-]*$||g')

# Get Package

cd /blfs/builds
wget $URL
wget https://www.linuxfromscratch.org/patches/blfs/svn/nss-standalone-1.patch
tar -xvf $TAR
cd $DIR

# Build
patch -Np1 -i ../nss-standalone-1.patch

cd nss

make BUILD_OPT=1                  \
  NSPR_INCLUDE_DIR=/usr/include/nspr  \
  USE_SYSTEM_ZLIB=1                   \
  ZLIB_LIBS=-lz                       \
  NSS_ENABLE_WERROR=0                 \
  $([ $(uname -m) = x86_64 ] && echo USE_64=1) \
  $([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1) -j16


# Install
sudo mkdir -p /pkgs/$PACKAGE
sudo mkdir -p /pkgs/$PACKAGE/usr/bin
sudo mkdir -p /pkgs/$PACKAGE/usr/lib
sudo mkdir -p /pkgs/$PACKAGE/usr/include
sudo mkdir -p /pkgs/$PACKAGE/usr/lib/pkgconfig

cd ../dist                                                          &&

install -v -m755 Linux*/lib/*.so             /pkgs/$PACKAGE/usr/lib              &&
install -v -m644 Linux*/lib/{*.chk,libcrmf.a}  /pkgs/$PACKAGE/usr/lib              &&

install -v -m755 -d                            /pkgs/$PACKAGE/usr/include/nss      &&
cp -v -RL {public,private}/nss/*               /pkgs/$PACKAGE/usr/include/nss      &&
chmod -v 644                                   /pkgs/$PACKAGE/usr/include/nss/*    &&

install -v -m755 Linux*/bin/{certutil,nss-config,pk12util}  /pkgs/$PACKAGE/usr/bin &&

install -v -m644 Linux*/lib/pkgconfig/nss.pc   /pkgs/$PACKAGE/usr/lib/pkgconfig


cd /pkgs
sudo cp -rpv $PACKAGE/* /
ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so

sudo echo "nspr sqlite" > /pkgs/$PACKAGE/depends
sudo echo "ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so" > /pkgs/$PACKAGE/postinst
sudo tar -cvzpf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished


cd /blfs/builds
sudo rm -r $DIR


