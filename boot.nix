{pkgs, ...}:

{
  boot.loader = {
    systemd-boot.enable = false;

    grub = {
      enable = true;

      device = "nodev";
      efiSupport = true;
      useOSProber = true;

      theme = ./custom/configs/non-nix/grub-theme;
    };

    efi.canTouchEfiVariables = true;
  };

  boot.supportedFilesystems = [ "btrfs" ];

  boot.kernelModules = [ "tun" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
