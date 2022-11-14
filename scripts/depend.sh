#!/bin/bash
string=$(echo $1 | sed "s/\,//g" | sed 's/and//g' | tr '[:upper:]' '[:lower:]')
echo $string

