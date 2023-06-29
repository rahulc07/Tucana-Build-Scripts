#!/bin/bash
# This initalizes building packages based on the currency check output for the day

# Again, this is some of the worst yet most functional code I have ever written.  Please read everything twice before assuming that something doesn't work. 
# To use this script you have to change paths in 3 files, convert_txt_to_script.sh (run the build_new_currency function to make a new currency.sh), $BUILD_SCRIPTS_ROOT/scripts/generate_pkgvers.sh and this file to make the currency checks work.

# Where the currency check script is located and where it is outputting to
CURRENCY_ROOT=/home/rahul/lfs/autobuild/currency/
# Where the build scripts are
BUILD_SCRIPTS_ROOT=/home/rahul/lfs/build-scripts/
# Special variable when rebuilding the currency.sh file is needed
CURRENCY_TXT_LOCATIONS=/home/rahul/lfs/currency-scripts-needed
LOG_ROOT=/home/rahul/lfs/update-logs/
# Set IFS to new lines only, globally, can cause some weird errors if you unset this
build_new_currency() {
 cd $CURRENCY_TXT_LOCATIONS
 find . -type f | while IFS= read -r txt; do
  bash $BUILD_SCRIPTS_ROOT/scripts/convert_txt_to_script.sh  $txt
 done
}
email_upgrades() {

cd $CURRENCY_ROOT

# Make the file to email
echo "From: Tucana Autobuild Tool
Subject: Tucana Build Outline for $(date '+%B %d %Y')
Tucana Currency Check for $(date '+%B %d %Y')
Packages that are going to be built:
Package name: (Version in repo)   (Version going to be built)

" > $CURRENCY_ROOT/email_upgrades.txt 


for PACKAGE in $UPGRADE_PACKAGES; do
  echo "$PACKAGE: $(cat $CURRENCY_ROOT/all-pkgver.txt | grep $PACKAGE | sed 's/.*://g') $(echo "$NEW_VERSIONS" | grep $PACKAGE | sed 's/.*://')" >> $CURRENCY_ROOT/email_upgrades.txt
done

# Email the file (do this your own way this script will NOT be released)
/home/rahul/lfs/email_from_tucana.sh email_upgrades.txt

}

notify_failed_package() {
cd $CURRENCY_ROOT
# Error code 1 = General Build Failure
# Error Code 2 = Currency Check Failure
local code=$2
local package=$1
if [[ $code == 2 ]]; then
  email_string="due to a currency check failure"
else
  email_string="due to a build failure, logs can be found at $LOG_ROOT"
fi
echo "From: Tucana Auto Build Tool
Subject: Tucana build failure $package $(date '+%m-%d-%Y') 
Tucana Autobuild System
The package $package failed to build $email_string

---
TAS " > failed_$package.txt

# Email
echo "Emailing Results"
/home/rahul/lfs/email_from_tucana.sh failed_$package.txt
}
# Generate the currency check script
echo "Generating Currency Check Script"
build_new_currency
# Run the currency check
echo "Running Currency"
cd $CURRENCY_ROOT
bash currency.sh
# Get the pkgvers in the Repo at that moment
cd $BUILD_SCRIPTS_ROOT
echo "Getting current package versions"
scripts/generate_pkgvers.sh # The output variable in generate_pkgvers MUST point to the same folder as $CURRENCY_ROOT in this script


# Sort the currency output
cd $CURRENCY_ROOT
cat latest-ver.txt | sort > latest-ver-sorted.txt
# Diff the 2 to find new versions
NEW_VERSIONS=$(diff latest-ver-sorted.txt all-pkgver.txt | grep '<' | sed 's/<\ //g')
UPGRADE_PACKAGES=$(echo "$NEW_VERSIONS" | sed 's/:.*//')
# Quick check to see if there are updates
if [[ $UPGRADE_PACKAGES == "" ]]; then
   echo "No updates found"
   exit 0
fi

# Make the email list
# Emailing outline of updates
email_upgrades

# Store the upgrade packages just in case this script crashes 
echo "$UPGRADE_PACKAGES" > $CURRENCY_ROOT/too-upgrade.tmp
echo "Changing versions"
# Change the versions within the build scripts
cd $BUILD_SCRIPTS_ROOT


# Both of these have highly predictable input and will NEVER contain special characters or spaces don't @ me for not using a while loop here, using a for loop makes the code for readable and faster. 
for PACKAGE in $UPGRADE_PACKAGES; do
  echo "Changing $PACKAGE PKG_VER"
  LOCATION=$(find . -type f -name $PACKAGE)
  # Quick sanity check to make sure that the currency script didn't fail
  echo "$NEW_VERSIONS" | grep $PACKAGE | grep -E ': [0-9]+' &> /dev/null
  if [[ $? -ne 0 ]]; then
     echo "Currency check on $PACKAGE FAILED! Removing from upgrade list"
     NEW_VERSIONS1=$(echo "$NEW_VERSIONS" | sed "s/.*$PACKAGE.*//")
     NEW_VERSIONS="$NEW_VERSIONS1"
     notify_failed_package "$PACKAGE" "2"
  else
     echo "$PACKAGE passed currency checks"
     sed -i "s/PKG_VER=.*/PKG_VER=$(echo "$NEW_VERSIONS" | grep $PACKAGE | sed 's/.*:\ //')/g" $LOCATION
  fi
done


echo "Preparing for build"
# Prepare to do the final build (assuming host system is clean)
cd $BUILD_SCRIPTS_ROOT
mkdir -p /finished /pkgs /blfs/builds/
rm -rf /blfs/builds/* /pkgs/*
mkdir -p $LOG_ROOT

# Build the updates
for PACKAGE in $UPGRADE_PACKAGES; do 
   cd $BUILD_SCRIPTS_ROOT
   LOCATION=$(find . -type f -name $PACKAGE)
   echo "Building $PACKAGE"
   bash -e $LOCATION &> $LOG_ROOT/$PACKAGE-$(date '+%m-%d-%Y').log
   if [[ $? -ne 0 ]]; then
     notify_failed_package "$PACKAGE" "1"
     sleep 2
   else
     SUCCESSFUL_PACKAGES="$SUCCESSFUL_PACKAGES $PACKAGE"
   fi
done

echo $SUCCESSFUL_PACKAGES
