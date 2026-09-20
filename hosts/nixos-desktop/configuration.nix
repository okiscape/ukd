{ pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./customization.nix
      ./boot.nix
  ];
  nix.settings.experimental-features = [
    "nix-command" "flakes"
  ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };


  networking.hostName = "atom-nixos";

  networking.networkmanager.enable = true;
  networking.enableIPv6 = false;

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.okiscape = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
      "audio"
      "input"
      "wireshark"
      "wallpapers"
    ];
    shell = pkgs.bash;
    packages = with pkgs; [
      tree
    ];
  };

  services.dbus.enable = true;


  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };
  boot.initrd.kernelModules = [ "xe" ];

  system.stateVersion = "26.05";

}
