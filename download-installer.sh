#!/bin/bash

curl -O https://raw.githubusercontent.com/dumanshr/arch-install/master/arch-install.sh
curl -O https://raw.githubusercontent.com/dumanshr/arch-install/master/after-chroot.sh
curl -O https://raw.githubusercontent.com/dumanshr/arch-install/master/install-gnome.sh
curl -O https://raw.githubusercontent.com/dumanshr/arch-install/master/envfile.sample


chmod +x arch-install.sh
chmod +x after-chroot.sh
chmod +x install-gnome.sh
cp envfile.sample envfile