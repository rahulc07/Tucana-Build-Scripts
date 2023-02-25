#!/bin/bash
sed -i "s|echo\ \"\"\ > /pkgs/.*/depends|echo\ \"$2\" > /pkgs/\$PACKAGE/depends|"  $1
