#!/bin/bash


. /install/envfile

cat /proc/cpuinfo | grep -i vendor_id | grep -i intel
intel_cpu=$?

cat /proc/cpuinfo | grep -i vendor_id | grep -i amd
amd_cpu=$?

if [[ $intel_cpu -eq 0 ]]; then
	pacman -S intel-ucode
elif [[ $amd_cpu -eq 0 ]]; then
	pacman -S amd-ucode
else
	echo "CPU manufacturer could not be determined"
fi


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

echo $hostname > /etc/hostname
echo "127.0.0.1 	localhost" > /etc/hosts
echo "127.0.1.1 	$hostname" >> /etc/hosts
echo "::1 	localhost" >> /etc/hosts


ROOT_UUID=$(blkid -s UUID -o value $(bootctl -R ))

# For btrfs
#echo "root=UUID=${ROOT_UUID} rootflags=subvol=@ rw quiet splash nvidia_drm.modeset=1" >/etc/kernel/cmdline

#ext4
kernel_cmdline="root=UUID=${ROOT_UUID} rw quiet splash"
lspci | grep -i nvidia

if [[ $? -eq 0 ]]; then
	kernel_cmdline="$kernel_cmdline nvidia_drm.modeset=1"
fi
echo $kernel_cmdline >/etc/kernel/cmdline

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

MACHINE_ID=$(cat /etc/machine-id)
mkdir -p /efi/${MACHINE_ID}

EFI_DIR="/efi/${MACHINE_ID}"
echo "EFI_DIR='$EFI_DIR'" > /etc/mkinitcpio.d/linux.preset
echo "ALL_kver=\"\${EFI_DIR}/vmlinuz-linux\"" >>/etc/mkinitcpio.d/linux.preset
echo "PRESETS=('default')" >>/etc/mkinitcpio.d/linux.preset
echo "default_image=\"\${EFI_DIR}/initramfs-linux.img\"" >>/etc/mkinitcpio.d/linux.preset


echo "title $hostname" >/efi/loader/entries/${MACHINE_ID}-linux.conf
echo "linux /${MACHINE_ID}/vmlinuz-linux" >>/efi/loader/entries/${MACHINE_ID}-linux.conf
echo "initrd /${MACHINE_ID}/initramfs-linux.img" >>/efi/loader/entries/${MACHINE_ID}-linux.conf
echo "options $kernel_cmdline" >>/efi/loader/entries/${MACHINE_ID}-linux.conf





pacman -S --needed --noconfirm linux

rm -r /install

if [[ -n $password ]]; then
	echo -n "$username:$password" | chpasswd
else
	passwd $username
fi