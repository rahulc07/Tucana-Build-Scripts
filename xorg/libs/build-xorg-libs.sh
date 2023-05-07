#!/bin/bash
export CFLAGS=-"O2"
export CXXFLAGS="-O2"

# Do the build in the right order
bash xtrans
bash libX11
bash libXext
bash libFS
bash libICE
bash libSM
bash libXScrnSaver
bash libXt
bash libXmu
bash libXpm
bash libXaw
bash libXfixes
bash libXcomposite
bash libXrender
bash libXcursor
bash libXdamage
bash libfontenc
bash libXfont2
bash libXft
bash libXi
bash libXinerama
bash libXrandr
bash libXres
bash libXtst
bash libXv
bash libXvMC
bash libXxf86dga
bash libXxf86vm
bash libdmx
bash libpciaccess
bash libxkbfile
bash libxshmfence
bash xorg-libs
