#!/bin/bash
export CFLAGS=-"O2"
export CXXFLAGS="-O2"

# Specify Location of Build Scripts
SCRIPTS_LOCATION=/mnt/

# Rebuild all packages/requested packages in the repo

build_package() {

bash -e $(find . -name $1)
# Check for errors
if [[ $? != 0 ]];then
   echo "$1 has had en error"
   $1 >> /var/log/build_error.log
fi

}


# Add packages to build queue
# Root Packages
PACKAGES=" $(find $SCRIPTS_LOCATION -maxdepth 1 -type f | sed 's|.*/||g')"

# Base packages
PACKAGES+=" $(find $SCRIPTS_LOCATION/base -maxdepth 1 -type f | sed 's|.*/||g')"

# Python Modules
PACKAGES+=" build_python_mods.sh"

# Gnome
PACKAGES+=" $(find $SCRIPTS_LOCATION/gnome -maxdepth 1 -type f | sed 's|.*/||g')"

# Xorg
PACKAGES+=" $(find $SCRIPTS_LOCATION/xorg  -maxdepth 1 -type f | sed 's|.*/||g')"

# Xorg-Libs
PACKAGES+=" $(find $SCRIPTS_LOCATION/xorg/libs/build-xorg-libs.sh -type f | sed 's|.*/||g')"

# XFCE4
PACKAGES+=" $(find $SCRIPTS_LOCATION/xfce4  -maxdepth 1 -type f | sed 's|.*/||g')"

# KDE
PACKAGES+=" $(find $SCRIPTS_LOCATION/kde  -maxdepth 1 -type f | sed 's|.*/||g')"

# Lib32-Root
PACKAGES+=" $(find $SCRIPTS_LOCATION/lib32  -maxdepth 1 -type f | sed 's|.*/||g')"
# Lib32-xorg
PACKAGES+=" $(find $SCRIPTS_LOCATION/lib32/lib32-xorg/libs/lib32-build-xorg-libs.sh -type f | sed 's|.*/||g')"
echo $PACKAGES
for package in $PACKAGES; do
   build_package "$package"
done
   
