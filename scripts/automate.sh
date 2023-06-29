#!/bin/bash
PACKAGE=$1
PACKAGE_LOCATION=$(find . -name $PACKAGE)

PACKAGE_VER() {
  cat $PACKAGE_LOCATION | grep PKG_VER=
  if [[ $? == 0 ]]; then
    echo "Package already has a PKG_VER skipping"
    echo "$PACKAGE: $(cat $PACKAGE_LOCATION | grep PKG_VER= | sed 's/PKG_VER=//')" >> /home/rahul/all-pkgver.txt
    echo "URL is $(cat $PACKAGE_LOCATION | grep URL=)"
    return 0
  else
    cat $PACKAGE_LOCATION | grep URL=
    read -r -p "What is the Package Version: " pkgver
    read -r -p "Major or none[M/N]: " MRN
    sed -i 's/URL=/\'$'\nURL=/g' $PACKAGE_LOCATION
    if [[ $MRN == "n" ]]; then
     sed -i "s/$pkgver/\$PKG_VER/g" $PACKAGE_LOCATION
     sed -i -r "s/URL=/PKG_VER=$pkgver\nURL=/" $PACKAGE_LOCATION
    elif [[ $MRN == "m" ]]; then
     sed -i "s/$pkgver/\$PKG_VER/g" $PACKAGE_LOCATION
     MAJOR=$(echo $pkgver | sed 's|.[^.]*$||g')
     sed -i "s/$MAJOR/\$MAJOR/g" $PACKAGE_LOCATION
     sed -i "s/URL=/PKG_VER=$pkgver\nMAJOR=\$(echo \$PKG_VER | sed 's|.[^.]*$||g')\nURL=/" $PACKAGE_LOCATION
    fi
  fi
  echo "URL is $(cat $PACKAGE_LOCATION | grep URL=)"
  echo "$PACKAGE: $pkgver" >> /home/rahul/all-pkgver.txt
   }
CURRENCY_CHECK_TEXT() {
  # Currency Check module
  read -r -p "Currency Check script to attempt
  1) Standard
  2) Recursive Standard (Including Major)
  3) Github
  4) Gnome
  5) Gnome (DE)
  6) Sourceforge
  7) Arch
  8)Gitlab
  9) Other
  : " currency
  echo "Attempting to find latest version"
  SCRIPTS_PATH=/home/rahul/lfs/Currency-Checks
 NEW_PKG_VER=$(  if [[ $currency == "1" ]]; then
    $SCRIPTS_PATH/classic-parse.sh $PACKAGE
  fi
  
  if [[ $currency == 2 ]]; then
     $SCRIPTS_PATH/recursive-parse.sh $PACKAGE
  fi
  
  if [[ $currency == 3 ]]; then
     $SCRIPTS_PATH/github-api-scrape.sh $PACKAGE
  fi
  
  if [[ $currency == 4 ]]; then
     $SCRIPTS_PATH/gnome-scrape-parse.sh $PACKAGE
  fi
  if [[ $currency == 5 ]]; then
     GNOME_DE=1 $SCRIPTS_PATH/gnome-scrape-parse.sh $PACKAGE
  fi
  if [[ $currency == 6 ]]; then
     $SCRIPTS_PATH/sourceforge.sh $PACKAGE
  fi
  if [[ $currency == 7 ]]; then
     $SCRIPTS_PATH/do_it_via_arch.sh $PACKAGE
  fi
  if [[ $currency == 8 ]]; then
     $SCRIPTS_PATH/gitlab-api-scrape.sh $PACKAGE
  fi
  if [[ $currency == 9 ]]; then
     read -r -p "Enter file path: " file_path_other
     $SCRIPTS_PATH/$file_path_other $PACKAGE
     currency="$file_path_other"
     echo "$PACKAGE: $file_path_other" >> /home/rahul/currency.txt
  
  fi)
  echo $NEW_PKG_VER
  read -r -p "Good? [y/n]" good
  if [[ $good == "y" ]]; then
    if [[ $currency == 9 ]]; then 
         :
    else
      echo "$PACKAGE: $currency" >> /home/rahul/currency.txt
    fi
    read -r -p "Switch PKG_VER? [y/n]" switch1
    
    if [[ $switch1 == "y" ]]; then
      sed -i "s/PKG_VER=.*/PKG_VER=$NEW_PKG_VER/" $PACKAGE_LOCATION
    fi
    return 0
  else
    return 1
  fi
} 

PACKAGE_VER
CURRENCY_CHECK_TEXT
until [[ $? == 0 ]]; do
  CURRENCY_CHECK_TEXT
done
