#!/bin/bash
mkdir -p /logs/cinnamon-logs 

build() {
   bash $1 &> /logs/cinnamon-logs/$1-$(date '+%m-%d-%Y').log
   if [[ ! $? == 0 ]]; then
      echo $1 >> /logs/cinnamon-logs/failed.txt
   fi
}
build "python3-xapp"
build "cjs"
build "cinnamon-desktop"
build "cinnamon-settings-daemon"
build "cinnamon-menus"
build "cinnamon-control-center"
build "cinnamon-session"
build "cinnamon-screensaver"
build "cinnamon"
build "muffin"
build "nemo"
