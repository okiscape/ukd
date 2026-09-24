echo " # scripts/nix/install.sh starting..."

CUR_DIR="$(cd "$(dirname "$0")" && pwd)"
LIB_DIR="$(cd "$CUR_DIR/../../scripts/lib" && pwd)"
REPO_DIR="$(cd "$CUR_DIR/../.." && pwd)"

. "$REPO_DIR/scripts/lib/ask.sh"
. "$REPO_DIR/scripts/lib/confirm.sh"
. "$REPO_DIR/scripts/lib/menu.sh"

echo ""
echo " --- hardware-configuration.nix ---"
if [ -f hardware-configuration.nix ]; then
    echo "  > hardware-configuration.nix already exists"
    if confirm " ? regenerate hardware-configuration.nix?"; then
        sh "$CUR_DIR/hardware_configuration.sh" --force
    fi
else
    echo "  > hardware-configuration.nix not found, generating..."
    sh "$CUR_DIR/hardware_configuration.sh"
fi

echo ""
echo " --- bootloader ---"
BOOTLOADER=$(menu "select bootloader:" "grub (default)" "systemd-boot")

case "$BOOTLOADER" in
    grub*)
        GRUB_DEVICE=$(ask " ? grub install device" "/dev/sda")
        GRUB_EFI=$(confirm " ? grub efi support?" "y" && echo "true" || echo "false")
        GRUB_PROBER=$(confirm " ? enable os-prober (multi boot)?" "y" && echo "true" || echo "false")

        echo "  > writing boot.nix with grub settings..."

        cat > boot.nix <<NIXEOF
{pkgs, ...}:

{
  boot.loader = {
    systemd-boot.enable = false;

    grub = {
      enable = true;

      device = "${GRUB_DEVICE}";
      efiSupport = ${GRUB_EFI};
      useOSProber = ${GRUB_PROBER};

      theme = ../../common/grub-theme;
    };

    efi.canTouchEfiVariables = true;
  };

  boot.supportedFilesystems = [ "btrfs" ];

  boot.kernelModules = [ "tun" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
NIXEOF
        echo "  > boot.nix written"
        ;;

    systemd-boot*)
        echo "  > writing boot.nix with systemd-boot settings..."

        cat > boot.nix <<NIXEOF
{pkgs, ...}:

{
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
    };

    grub.enable = false;

    efi.canTouchEfiVariables = true;
  };

  boot.supportedFilesystems = [ "btrfs" ];

  boot.kernelModules = [ "tun" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
NIXEOF
        echo "  > boot.nix written"
        ;;
esac


echo ""
if confirm "\"nixos-rebuild switch\" now?"; then
    echo " - - - - - - - "
    sudo nixos-rebuild switch --flake ".#${HOSTNAME}"
    echo " - - - - - - - "
else
    echo " ! ok, bye"
fi
