#!/usr/bin/env sh
set -eu

echo " # ubuntu-server/root.sh starting (full system install, run from livecd)"

echo " ! this module currenly not available, we're working on it. stay tuned!"


# \/ AI WRITTEN, NEEDS CHECK AND DEBUGGING

# CUR_DIR="$(cd "$(dirname "$0")" && pwd)"
# REPO_DIR="$(cd "$CUR_DIR/../.." && pwd)"

# . "$REPO_DIR/scripts/lib/ask.sh"
# . "$REPO_DIR/scripts/lib/confirm.sh"

# if [ "$(id -u)" -ne 0 ]; then
#     echo " ! root.sh must run as root (sudo)" >&2
#     exit 1
# fi

# DEVICE=$(ask " ? target disk (e.g. /dev/sda, /dev/nvme0n1)" "/dev/sda")
# CODENAME=$(ask " ? ubuntu codename (24.04=noble, 24.10=oracular, 25.04=plucky)" "noble")
# MIRROR=$(ask " ? mirror (deb.debian.org / archive.ubuntu.com)" "deb.debian.org")

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
# parted -s "$DEVICE" mkpart "root" ext4 1025MiB 100%

# echo " --- formatting..."
# mkfs.fat -F32 "$EFI_PART"
# mkfs.ext4 -F "$ROOT_PART"

# echo " --- mounting..."
# mount "$ROOT_PART" /mnt
# mkdir -p /mnt/boot/efi
# mount "$EFI_PART" /mnt/boot/efi

# echo " --- debootstrap (base system)..."
# debootstrap --arch=amd64 --variant=minbase "$CODENAME" /mnt "http://$MIRROR/ubuntu"

# echo " --- installing packages..."
# PACKAGES=$(grep -v '^#' "$CUR_DIR/packages.txt" | tr '\n' ' ')
# # shellcheck disable=SC2086
# chroot /mnt apt-get update
# # shellcheck disable=SC2086
# chroot /mnt apt-get install -y $PACKAGES

# echo " --- generating fstab..."
# ROOT_UUID=$(blkid -s UUID -o value "$ROOT_PART")
# EFI_UUID=$(blkid -s UUID -o value "$EFI_PART")
# cat > /mnt/etc/fstab <<EOF
# UUID=$ROOT_UUID / ext4 defaults,noatime 0 1
# UUID=$EFI_UUID /boot/efi vfat umask=0077 0 1
# EOF

# HOSTNAME=$(ask " ? hostname" "ubuntu-server")
# SERVER_USER=$(ask " ? server user" "okiscape")

# cat > /mnt/root/setup-chroot.sh <<EOF
# #!/usr/bin/env sh
# set -eu

# ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
# dpkg-reconfigure -f noninteractive tzdata

# echo "LANG=en_US.UTF-8" > /etc/default/locale
# echo "$HOSTNAME" > /etc/hostname

# useradd -m -s /bin/bash "$SERVER_USER"
# echo "-- user: set password"
# passwd "$SERVER_USER"
# usermod -aG sudo,adm,storage $SERVER_USER

# echo "-- root: set password"
# passwd

# GRUB_DEVICE=$(findmnt -n -o SOURCE / | sed 's/[0-9]*$//')
# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ubuntu
# grub-mkconfig -o /boot/grub/grub.cfg

# systemctl enable networkd-dispatcher
# EOF

# chmod +x /mnt/root/setup-chroot.sh
# chroot /mnt /root/setup-chroot.sh
# rm /mnt/root/setup-chroot.sh

# umount -R /mnt

# echo ""
# echo " ^ full ubuntu server installed!"
# echo " > reboot, then run:  git clone <repo> && sudo sh install.sh  (install configuration)"
