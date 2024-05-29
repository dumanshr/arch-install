#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

clear
echo -e "Before you begin, Please note everything are case sensitive\n"

echo "Select Mount Points"
echo "You can skip this step by pressing Y if you have already mounted"
echo "the installation root (/) to /mnt and efi partition to /mnt/efi"
printf "already mounted correctly? (y/N): "

read premounted

[[ x${premounted} != xy && x${premounted} != xY ]] && unset premounted ;

if [[ -z ${premounted} ]]; then
	lsblk 

	echo "example for device /dev/nvme0n1p3 only write nvme0n1p3"
	printf "root partition (/): /dev/"
	read ROOT_DEV
	ROOT_DEV="/dev/${ROOT_DEV}"

	EFI_GUESS=$(fdisk -l /dev/$(lsblk -no pkname $ROOT_DEV) | grep EFI | awk '{print $1}')

	
	printf "\nEFI:\nEnter correct partition if default is incorrect\n"
	printf "efi partition (default $EFI_GUESS): /dev/"
	read EFI_DEV
	if [[ -n $EFI_DEV ]]; then
		EFI_DEV="/dev/${EFI_DEV}"
	else
		EFI_DEV=$EFI_GUESS
	fi
	
	if [[ ! -b ${ROOT_DEV} || ! -b ${EFI_DEV} ]]; then
		echo "One or more block storage device not found"
		echo "Write the device name correctly OR"
		echo "Please use fdisk or parted or gparted to part your disk"
		exit
	fi
	
fi

if [[ -n $1 && -f $1 ]]; then
. $1

else

	printf "\nChoose an USERNAME: "
	read username
	echo "Choose a password for this user (space at the biginning and at the end are ignored) "
	echo -n "Password: "
	read password

	printf "Hostname (give a name to the OS): "
	read hostname

	echo -e "\nEnter your timezone (e.g. America/New_York)"
	echo "If you are not sure, leave it empty or find your timezone in /usr/share/zoneinfo"
	echo "and run this installer again"

	printf "\ntimezone (default UTC): "
	read timezone

	if [[ ! -f "/usr/share/zoneinfo/$timezone" ]]; then
		echo "Timezone not found"
		timezone=""
	fi

	echo -e "\nEnter your locale (e.g. en_US.UTF-8 )"
	echo "If you are not sure, leave it empty for default Or find your locale in /etc/locale.gen file"
	echo "and run this installer again"

	printf "\nlocale (default en_US.UTF-8): "
	read locale

	if [[ ${#locale} -lt 5 ]]; then
		echo "locale not found"
		locale=""

	else
		found_locale=$(grep $locale /etc/locale.gen | wc -l)
		if [[ $found_locale -eq 0 ]]; then
			echo "locale not found"
			timezone=""
		fi
	fi

	echo -e "\nEnter your keyboard layout (e.g. us )"
	echo "If you are not sure, leave it default OR find on arch install page and"
	echo "and run this installer again"

	printf "\nlocale (default us): "
	read keyboard

	printf "Do you want to install desktop env? (y/N): "
	read desktop
fi

if [[ -z $premounted ]]; then
	echo -e "\nIMPORTANT:"
	echo "Please confirm the devices you selected are correct"
	echo "Root partition will be formated. You will lose all"
	echo "your data there. If EFI partition is incorrect,"
	echo "you will not be able to boot to the new system."

	echo ""
	echo -e "Root partition (/) \t: ${ROOT_DEV}"
	echo -e "EFI partition (/efi)\t: ${EFI_DEV}"
else
	echo -e "Root partition (/) \t: /mnt\t(premounted)"
	echo -e "Root partition (/efi)\t: /mnt/efi\t(premounted)"		
fi



show_details(){
	echo "hostname='$hostname'"
	echo "username='$username'"
	echo "password='$password'"
	echo "timezone='$timezone'"
	echo "locale='$locale'"
	echo "desktop=$desktop"
	echo "keyboard=$keyboard"
}
show_details
printf "Is everything correct? (y/N): "
read confirm
if [[ x${confirm} != xy && x${confirm} != xY ]]; then
	echo "Please run $0 again"
	exit
fi
show_details > envfile
if [[ -z $premounted ]]; then
	echo "Mounting"
	umount --recursive /mnt
	mkfs.ext4 -F ${ROOT_DEV}
	mount ${ROOT_DEV} /mnt
	mount --mkdir $EFI_DEV /mnt/efi
fi

pacman-key --init
pacman-key --populate


pacstrap /mnt \
	base base-devel mkinitcpio linux-headers linux-firmware intel-ucode \
	terminus-font networkmanager neovim micro tmux git wget rsync \
	e2fsprogs btrfs-progs dosfstools ntfs-3g

mkdir -p /mnt/install/
cp after-chroot.sh /mnt/install/
cp install-gnome.sh /mnt/install/
cp envfile /mnt/install/
cp -r assets /mnt/install/

genfstab -U /mnt >/mnt/etc/fstab

echo "CHROOT"

arch-chroot /mnt bash /install/after-chroot.sh

echo "Do you want to customize more your new system?"
printf "(Y/n): "
read stay_more
if [[ (x${stay_more} != xn && x{stay_more} != xN) ]]; then
	arch-chroot /mnt
fi

umount --recursive /mnt


