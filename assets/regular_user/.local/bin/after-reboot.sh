#!/bin/bash
# this script is invoked by autostart/firstconfig.desktop file

# show maximize minimize and close
timedatectl set-ntp true

gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

# Connect to the network first
nmtui


# Gnome Shell extensions 
gnome-extension-install ()
{
	gdbus call --session \
		--dest org.gnome.Shell.Extensions \
		--object-path /org/gnome/Shell/Extensions \
		--method org.gnome.Shell.Extensions.InstallRemoteExtension "$1"
}

gnome-extension-install "dash-to-panel@jderose9.github.com" # dash to dash
gnome-extension-install "appindicatorsupport@rgcjonas.gmail.com" # appindicator

# systemctl --user enable pipewire-pulse



sudo true



flatpak install -y \
	flathub \
	org.libreoffice.LibreOffice \
	org.onlyoffice.desktopeditors \
	com.obsproject.Studio \
	org.videolan.VLC \
	org.gimp.GIMP \
	org.kde.kdenlive \
	org.audacityteam.Audacity\
	us.zoom.Zoom \
	com.github.xournalpp.xournalpp \
	flathub com.github.tchx84.Flatseal

echo "Do you want to restart?: [y/N]: "
read confirm
rm $HOME/.config/autostart/firstconfig.desktop
if [[ xy == x$confirm || xY == x$confirm ]]; then
	reboot
fi

