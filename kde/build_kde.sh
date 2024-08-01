#!/bin/bash
set -e
# Building Depends
bash ecm
bash phonon
#bash phonon-backend-vlc
bash polkit-qt
bash plasma-wayland-protocols

# Plasma5-limited
cd plasma5-limited
bash -e build_plasma5_limited.sh
cd ..
# KF6
cd kf6
bash -e build_kf6.sh
cd ..
# Desktop
cd plasma
bash -e build_plasma.sh
cd ..
# Apps
cd plasma-apps
bash -e build_plasma_apps.sh
