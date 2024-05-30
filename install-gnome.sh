#!/bin/bash

pacman -S --needed --noconfirm --overwrite \* \
	sof-firmware alsa-firmware \
	gnome-shell gdm alacritty flatpak switcheroo-control\
	pipewire-pulse pipewire-alsa pipewire-jack wireplumber




pacman -S --needed --noconfirm --overwrite \* \
	nautilus \
	gnome-software \
	gnome-backgrounds \
	gnome-control-center \
	xdg-user-dirs-gtk \
	xdg-desktop-portal-gnome \
	gnome-keyring \
	gvfs-afc gvfs-goa gvfs-google gvfs-onedrive\
	gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb \
	evince totem loupe snapshot \
	gnome-font-viewer \
	gnome-disk-utility \
	gnome-remote-desktop \
	gnome-user-share \
	tracker3-miners \
	gnome-calculator \
	python-nautilus \
	xclip wl-clipboard

	

# Thumbnails
pacman -S --needed --noconfirm --overwrite \* \
	tumbler \
	ffmpegthumbnailer \
	poppler-glib\
	libgsf \
	libgepub \
	libopenraw \
	freetype2\
	webp-pixbuf-loader\
	gnome-epub-thumbnailer

# install following
pacman -S --needed --noconfirm --overwrite \* \
	neovim micro \
	rsync \
	less \
	git \
	curl wget \
	tmux \
	p7zip \
	qt6-base qt6-wayland \
	chromium \
	ffmpeg yt-dlp \
	gnu-free-fonts \
	ttf-roboto-mono-nerd


ln -sf /dev/null /etc/udev/rules.d/61-gdm.rules
ln -sf alacritty /usr/bin/xterm
systemctl enable gdm
systemctl enable switcheroo-control
systemctl enable bluetooth

pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
echo '[chaotic-aur]'>>/etc/pacman.conf
echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf

pacman -Syyu

pacman -S --needed --noconfirm --overwrite \* brave-bin sublime-text-4

mkdir -p /usr/share/nautilus-python/extensions
curl -o /usr/share/nautilus-python/extensions/open-in-terminal.py https://raw.githubusercontent.com/dumanshr/arch-install/master/assets/open-in-terminal.py


wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=16NGDYZo44nQTO7ZNm0eAI_NL8CkEB6_o' -O /tmp/win11-fonts.tar.zst
pacman -U --noconfirm '/tmp/win11-fonts.tar.zst'

curl -o /tmp/config-download.sh https://raw.githubusercontent.com/dumanshr/arch-install/master/assets/config-download.sh
chmod +x /tmp/config-download.sh
NORMAL_USER=$(id -un 1000)
cd /home/${NORMAL_USER}
su ${NORMAL_USER} /tmp/config-download.sh


fc-cache --force




