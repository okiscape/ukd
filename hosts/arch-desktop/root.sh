#!/usr/bin/env sh
set -eu

echo " # arch-desktop/root.sh starting (full system install, run from livecd)"

echo " ! this module currenly not available, we're working on it. stay tuned!"

# CUR_DIR="$(cd "$(dirname "$0")" && pwd)"
# REPO_DIR="$(cd "$CUR_DIR/../.." && pwd)"

# . "$REPO_DIR/scripts/lib/ask.sh"
# . "$REPO_DIR/scripts/lib/confirm.sh"

# if [ "$(id -u)" -ne 0 ]; then
#     echo " ! root.sh must run as root (sudo)" >&2
#     exit 1
# fi

# DEVICE=$(ask " ? target disk (e.g. /dev/sda, /dev/nvme0n1)")

# echo ""
# echo " ! ALL DATA ON $DEVICE WILL BE DESTROYED"
# if ! confirm " ? continue?"; then
#     echo " ! aborted"
#     exit 1
# fi

# echo ""
# echo " --- partitioning $DEVICE ..."
# EFI_PART="${DEVICE}1"
# ROOT_PART="${DEVICE}2"

# wipefs -a "$DEVICE"
# parted -s "$DEVICE" mklabel gpt
# parted -s "$DEVICE" mkpart "efi" fat32 1MiB 1025MiB
# parted -s "$DEVICE" set 1 esp on
# parted -s "$DEVICE" mkpart "root" btrfs 1025MiB 100%

# echo " --- formatting..."
# mkfs.fat -F32 "$EFI_PART"
# mkfs.btrfs -f "$ROOT_PART"

# echo " --- creating btrfs subvolumes..."
# mount "$ROOT_PART" /mnt
# btrfs subvolume create /mnt/@
# btrfs subvolume create /mnt/@home
# umount /mnt

# mount -o subvol=@ "$ROOT_PART" /mnt
# mkdir -p /mnt/home /mnt/boot
# mount -o subvol=@home "$ROOT_PART" /mnt/home
# mount "$EFI_PART" /mnt/boot

# echo " --- pacstrap (base system)..."
# pacstrap -K /mnt base base-devel linux linux-firmware linux-headers \
#     networkmanager btrfs-progs git

# echo " --- installing packages..."
# PACKAGES=$(grep -v '^#' "$CUR_DIR/packages.txt" | tr '\n' ' ')

# pacstrap /mnt $PACKAGES

# echo " --- generating fstab..."
# genfstab -U /mnt >> /mnt/etc/fstab

# HOSTNAME=$(ask " ? hostname" "arch-desktop")
# DESKTOP_USER=$(ask " ? desktop user")

# cat > /mnt/root/setup-chroot.sh <<EOF
# #!/usr/bin/env sh
# set -eu

# ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
# hwclock --systohc

# sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
# sed -i 's/^#ru_RU.UTF-8/ru_RU.UTF-8/' /etc/locale.gen
# locale-gen

# echo "LANG=en_US.UTF-8" > /etc/locale.conf
# echo "$HOSTNAME" > /etc/hostname

# useradd -m "$DESKTOP_USER"
# echo "-- user: set password"
# passwd "$DESKTOP_USER"
# usermod -aG wheel,audio,video,input,storage,network $DESKTOP_USER

# echo "-- root: set password"
# passwd

# sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# GRUB_DEVICE=$(findmnt -n -o SOURCE / | sed 's/[0-9]*$//')
# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
# grub-mkconfig -o /boot/grub/grub.cfg

# systemctl enable NetworkManager
# EOF

# chmod +x /mnt/root/setup-chroot.sh
# arch-chroot /mnt /root/setup-chroot.sh
# rm /mnt/root/setup-chroot.sh

# umount -R /mnt

# echo ""
# echo " ^ full system installed!"
# echo " > reboot, then run:  git clone <repo> && sudo sh install.sh  (full system installation)"
# echo " or just:  sh install.sh  (install configuration)"
