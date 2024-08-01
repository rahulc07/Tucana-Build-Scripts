#1/bin/bash


depends=$(/home/rahul/get-kde/get_kde.sh $1| grep -oP 'depends=\(\K[^\)]*' | head -1 | sed 's/$/\ /g' | sed 's/qt6-.*\ /qt6/g' | sed 's/gcc-libs/libgcc/g')
sed -i "45s/.*/sudo\ echo\ \"$depends\"\ \>\ \/pkgs\/\$PACKAGE\/depends/" $1

