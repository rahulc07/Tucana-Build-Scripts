#!/bin/bash

export CFLAGS=-"O2"
export CXXFLAGS="-O2"
PKG_VER=8.3.8
set -e
URL=https://www.php.net/distributions/php-$PKG_VER.tar.xz
TAR=$(echo $URL | sed -r 's|(.*)/||')
DIR=$(echo $TAR | sed 's|.tar.*||g')
PACKAGE=$(echo $DIR | sed 's|-[^-]*$||g')
set -e
# Get Package

cd /blfs/builds
wget $URL
tar -xvf $TAR
cd $DIR

# Build

./configure --prefix=/usr                \
            --sysconfdir=/etc            \
            --localstatedir=/var         \
            --datadir=/usr/share/php     \
            --mandir=/usr/share/man      \
            --without-pear               \
            --enable-fpm                 \
            --with-fpm-user=apache       \
            --with-fpm-group=apache      \
            --with-config-file-path=/etc \
            --with-zlib                  \
            --enable-bcmath              \
            --with-bz2                   \
            --enable-calendar            \
            --enable-dba=shared          \
            --with-gdbm                  \
            --with-gmp                   \
            --enable-ftp                 \
            --with-gettext               \
            --enable-mbstring            \
            --disable-mbregex            \
            --with-readline    


make -j16


# Install
sudo make INSTALL_ROOT=/pkgs/$PACKAGE install
mkdir -p /pkgs/$PACKAGE/etc
install -v -m644 php.ini-production /pkgs/$PACKAGE/etc/php.ini &&
install -v -m755 -d /usr/share/doc/php &&
install -v -m644    CODING_STANDARDS* EXTENSIONS NEWS README* UPGRADING* \
                    /usr/share/doc/php

echo "if [ -f /etc/php-fpm.conf.default ]; then
  mv -v /etc/php-fpm.conf{.default,} &&
  mv -v /etc/php-fpm.d/www.conf{.default,}
fi" > /pkgs/$PACKAGE/postinst

install -D -m644 sapi/fpm/php-fpm.service "/pkgs/$PACKAGE/usr/lib/systemd/system/php-fpm.service"
cd /pkgs



sudo echo "apache libxml2 curl zip pcre2" > /pkgs/$PACKAGE/depends
sudo echo "" > /pkgs/$PACKAGE/make-depends
sudo tar -cvzpf $PACKAGE.tar.xz $PACKAGE
sudo cp $PACKAGE.tar.xz /finished


cd /blfs/builds
sudo rm -r $DIR


