#!/bin/bash


FILE="$1"
#####################___CHANGE THESE___##########################
SCRIPTS_PATH=/home/rahul/lfs/Currency-Checks
OUTPUT=/home/rahul/lfs/autobuild/currency/currency.sh
LATEST_VER_OUTPUT=/home/rahul/lfs/autobuild/currency/latest-ver.txt
################################################################3
convert() {
# 1) Standard web
  if [[ $CURRENCY_SCRIPT == 1 ]]; then
     echo "echo \"$PACKAGE: \$($SCRIPTS_PATH/classic-parse.sh $PACKAGE)\" >> $LATEST_VER_OUTPUT" >> $OUTPUT
  # 2) Recursive 
   elif [[ $CURRENCY_SCRIPT == 2 ]]; then
    echo "echo \"$PACKAGE: \$($SCRIPTS_PATH/recursive-parse.sh $PACKAGE)\" >> $LATEST_VER_OUTPUT" >> $OUTPUT
  # 3)  Github
   elif [[ $CURRENCY_SCRIPT == 3 ]]; then
     echo "echo \"$PACKAGE: \$($SCRIPTS_PATH/github-api-scrape.sh $PACKAGE)\" >> $LATEST_VER_OUTPUT" >> $OUTPUT
  # 4) Gnome
   elif [[ $CURRENCY_SCRIPT == 4 ]]; then
     echo "echo \"$PACKAGE: \$($SCRIPTS_PATH/gnome-scrape-parse.sh $PACKAGE)\" >> $LATEST_VER_OUTPUT" >> $OUTPUT
  # 5) Gnome DE
   elif [[ $CURRENCY_SCRIPT == 5 ]]; then
     echo "echo \"$PACKAGE: \$(GNOME_DE=1 $SCRIPTS_PATH/gnome-scrape-parse.sh $PACKAGE)\" >> $LATEST_VER_OUTPUT" >> $OUTPUT
  # 6) Sourceforge
  
   elif [[ $CURRENCY_SCRIPT == 6 ]]; then
     echo "echo \"$PACKAGE: \$($SCRIPTS_PATH/sourceforge.sh $PACKAGE)\" >> $LATEST_VER_OUTPUT" >> $OUTPUT
  
   elif [[ $CURRENCY_SCRIPT == 7 ]]; then
     echo "echo \"$PACKAGE: \$($SCRIPTS_PATH/do_it_via_arch.sh $PACKAGE)\" >> $LATEST_VER_OUTPUT" >> $OUTPUT
   elif [[ $CURRENCY_SCRIPT == 8 ]]; then
     echo "echo \"$PACKAGE: \$($SCRIPTS_PATH/gitlab-api-scrape.sh $PACKAGE)\" >> $LATEST_VER_OUTPUT" >> $OUTPUT
   else
     echo "echo \"$PACKAGE: \$($SCRIPTS_PATH/$CURRENCY_SCRIPT $PACKAGE)\" >> $LATEST_VER_OUTPUT" >> $OUTPUT
    fi
} 
IFS='
'
for line in $(cat $FILE); do
  CONTENT=$line
  echo $CONTENT
  PACKAGE=$(echo $CONTENT | sed 's/:.*//g')
  CURRENCY_SCRIPT=$(echo $CONTENT | sed 's/.*:\ //g')
  convert
done
