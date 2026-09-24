{pkgs, inputs, ...}:

{
  imports = [
    ./configs/throne.nix
    ./configs/wireshark.nix
    ./configs/pipewire.nix
    ./configs/konawalls.nix
    # ./configs/lightdm.nix
  ];

  nixpkgs.config.allowUnfree = true;
  programs.uwsm.enable = true;
  security.polkit.enable = true;
  networking.firewall.checkReversePath = "loose";
  networking.firewall.allowedUDPPorts = [  ];

  environment.systemPackages = [
    # base
    pkgs.git pkgs.curl pkgs.vim pkgs.tmux pkgs.nixd
    pkgs.nil pkgs.package-version-server pkgs.btop
    pkgs.flatpak pkgs.gnumake pkgs.musl pkgs.gcc
    pkgs.btrfs-progs pkgs.efibootmgr pkgs.refind
    pkgs.os-prober pkgs.pipewire pkgs.playerctl

    # wm
    inputs.driftwm.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.uwsm pkgs.lightdm pkgs.slurp

    # ui, wallpapers
    pkgs.quickshell pkgs.awww pkgs.hellwal

    # wo/ ui utils
    pkgs.wl-clipboard pkgs.cliphist

    # wm helpers
    pkgs.hyprpicker pkgs.grim

    pkgs.bluez pkgs.blueman
    pkgs.throne pkgs.ark
  ];
}
