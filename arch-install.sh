#!/bin/bash

if (( $EUID != 0 )); then
    >&2 echo "Please run as root"
    exit
fi
if [[ -z $1 ]]; then
	>&2 echo "USAGE $0 <enfile>"
	exit
fi

envfile=$1
this_file_dir=$(dirname -- "${BASH_SOURCE[0]}")
. $envfile
clear
echo -e "Before you begin, Please note everything are case sensitive\n"


if [[ -z  ${root_partition} ]]; then
	echo "envfile does not have root_partition mentioned"
	printf "Do you want select a (new) root partition? (Y/n): "
	read tempvar
	if [[ x$tempvar == xn || x$tempvar == xN ]]; then
		premounted=y
	else
		select_mount=y
	fi
elif [[ ! -b ${root_partition} ]]; then
	echo "The block device ${root_partition} was not found"
	select_mount=y
else
	echo "Root partition: $root_partition"
fi

if [[ -n $select_mount ]]; then
	lsblk
	printf "root partition (/): /dev/"
	read tempvar
	root_partition=/dev/$tempvar
	if [[ ! -b ${root_partition} ]]; then
		echo "You did not enter a valid block device"
		exit
	fi
fi


if [[ -z $premounted ]]; then
	EFI_GUESS=$(fdisk -l /dev/$(lsblk -no pkname $root_partition) | grep EFI | awk '{print $1}')
	printf "\nEFI:\nEnter correct partition if default is incorrect\n"
	printf "efi partition (default $EFI_GUESS): /dev/"
	read efi_partition
	if [[ -n $efi_partition ]]; then
		efi_partition="/dev/${efi_partition}"
	else
		efi_partition=$EFI_GUESS
	fi

	if [[ ! -b ${efi_partition} ]]; then
		echo "device ${efi_partition} not found"
		echo "Write the device name correctly OR"
		echo "Please use fdisk or parted or gparted to part your disk"
		exit
	fi
fi




echo 
if [[ -z $premounted ]]; then
	echo -e "\nIMPORTANT:"
	echo "Please confirm the devices you selected are correct"
	echo "Root partition will be formated. You will lose all"
	echo "your data there. If EFI partition is incorrect,"
	echo "you will not be able to boot to the new system."

	echo ""
	echo -e "Root partition (/) \t: ${root_partition}"
	echo -e "EFI partition (/efi)\t: ${efi_partition}"
else
	echo -e "Root partition (/) \t: /mnt\t(premounted)"
	echo -e "Root partition (/efi)\t: /mnt/efi\t(premounted)"		
fi


echo 
echo "hostname='$hostname'"
echo "username='$username'"
if [[ -n $password ]]; then
	echo "password=**********"
fi
echo "timezone='$timezone'"
echo "locale='$locale'"
echo "desktop=$desktop"
echo "keyboard=$keyboard"


printf "Is everything correct? (y/N): "
read confirm
if [[ x${confirm} != xy && x${confirm} != xY ]]; then
	echo "Please run $0 again"
	exit
fi

if [[ -z $premounted ]]; then
	echo "Mounting"
	umount --recursive /mnt
	mkfs.btrfs -f ${root_partition}
	mount ${root_partition} /mnt
	btrfs subvolume create /mnt/@
	btrfs subvolume create /mnt/@home
	umount --recursive /mnt

	mount -o subvol=@ ${root_partition} /mnt
	mount --mkdir -o subvol=@home ${root_partition} /mnt/home
	mount --mkdir $efi_partition /mnt/efi
fi

pacman-key --init
pacman-key --populate


pacstrap /mnt \
	base base-devel mkinitcpio linux-headers linux-firmware \
	terminus-font networkmanager neovim micro tmux git wget rsync \
	e2fsprogs btrfs-progs dosfstools ntfs-3g

mkdir -p /mnt/install/

cp $this_file_dir/after-chroot.sh /mnt/install/
cp $this_file_dir/install-gnome.sh /mnt/install/
cp $envfile /mnt/install/
cp -r $this_file_dir/assets /mnt/install/

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


