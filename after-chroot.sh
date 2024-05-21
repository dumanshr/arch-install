#!/bin/bash


. /install/envfile

ln -sf nvim /usr/bin/vi
systemctl enable NetworkManager


sed -i "/^#$locale/s/#//" /etc/locale.gen
echo "LANG=$locale" >>/etc/locale.conf
echo "KEYMAP=$keyboard">/etc/vconsole.conf
echo "FONT=ter-132b" >> /etc/vconsole.conf
locale-gen

[[ -f /usr/share/zoneinfo/${timezone} ]] && ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime


sed -i '/%wheel ALL=(ALL:ALL) ALL/s/^#[ ]*//' /etc/sudoers
useradd -m -G wheel $username
echo -n "$username:$password" | chpasswd

echo $hostname > /etc/hostname
echo "127.0.0.1 	localhost" > /etc/hosts
echo "127.0.1.1 	$hostname" >> /etc/hosts
echo "::1 	localhost" >> /etc/hosts


ROOT_UUID=$(blkid -s UUID -o value $(bootctl -R ))

# For btrfs
#echo "root=UUID=${ROOT_UUID} rootflags=subvol=@ rw quiet splash nvidia_drm.modeset=1" >/etc/kernel/cmdline

#ext4
echo "root=UUID=${ROOT_UUID} rw quiet splash nvidia_drm.modeset=1" >/etc/kernel/cmdline

# Systemd Boot Uses PRETTY_NAME from /etc/os-release to display on Boot Order
# If you want to install mulitple OS, then all named Arch Linux is very confusing.So Put Hostname as PRETTY_NAME,
# but put Arch before the Hostname if Hostname does not contain Arch.
# it is necessary to neofetch to know the os.

sed -i "/^PRETTY_NAME=/s/PRETTY_NAME.*/PRETTY_NAME=\"Arch ${hostname//Arch/}\"/" /etc/os-release




if [[ x${desktop} == xy ||  x${desktop} == xY  ]]; then
	echo "Installing desktop environment"
	bash /install/install-gnome.sh
fi



bootctl install
echo "timeout 	3" >/efi/loader/loader.conf
echo "default 	@saved">>/efi/loader/loader.conf

sed -i "/^PRESETS/c\PRESETS=('default')" /etc/mkinitcpio.d/linux.preset
sed -i "/^default_image/d" /etc/mkinitcpio.d/linux.preset
sed -i "/^#default_uki/s/#//" /etc/mkinitcpio.d/linux.preset
sed -i "/^#default_options/s/#//" /etc/mkinitcpio.d/linux.preset


mkinitcpio -P

rm -r /install