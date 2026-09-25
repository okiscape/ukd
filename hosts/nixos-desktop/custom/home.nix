{pkgs, inputs, lib, ...}:
let
  ukdignore = import ../lib/ukdignore.nix {inherit lib;};
  programModules = {
    konawalls = ./configs/konawalls.nix;
    driftwm = ./configs/driftwm.nix;
    kitty = ./configs/kitty.nix;
    starship = ./configs/starship.nix;
    fish = ./configs/fish.nix;
    fastfetch = ./configs/fastfetch.nix;
    quickshell = ./configs/quickshell.nix;
    hellwal = ./configs/hellwal.nix;
  };
  enabledModules = ukdignore.filterModules programModules;
in
{
  home.username = "okiscape";
  home.homeDirectory = "/home/okiscape";
  home.stateVersion = "24.05";

  home.packages = [
    # entertainment
    pkgs.osu-lazer-bin pkgs.prismlauncher pkgs.komikku pkgs.discord
    pkgs.betterdiscord-installer pkgs.steam pkgs.cavalier pkgs.cava
    pkgs.minesweep-rs pkgs.cowsay pkgs.librepods pkgs.libreoffice
    pkgs.kew inputs.konawalls.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.figlet

    # code
    pkgs.neovim pkgs.zed-editor pkgs.wakatime-cli  pkgs.opencode
    pkgs.vscodium pkgs.rustc pkgs.rustup pkgs.go pkgs.docker
    pkgs.pnpm pkgs.ollama pkgs.python3 pkgs.protobuf pkgs.cmake
    pkgs.docker-compose pkgs.jq pkgs.android-tools

    # reverse
    pkgs.nmap pkgs.lsplug pkgs.minicom pkgs.openocd pkgs.flashrom
    pkgs.binwalk pkgs.file pkgs.usbutils pkgs.i2c-tools pkgs.wireshark
    pkgs.aircrack-ng pkgs.bluez-tools pkgs.avahi pkgs.arp-scan

    # data
    pkgs.nicotine-plus pkgs.qbittorrent pkgs.kdePackages.filelight
    pkgs.kdePackages.dolphin pkgs.gparted pkgs.yazi pkgs.ffmpeg
    pkgs.yt-dlp pkgs.mpv pkgs.localsend pkgs.sqlite
    pkgs.postgresql pkgs.duf

    # art
    pkgs.kdePackages.kdenlive pkgs.opentabletdriver pkgs.krita
    pkgs.blender pkgs.ardour pkgs.obs-studio

    # term
    pkgs.fish pkgs.nerd-fonts.geist-mono pkgs.kitty pkgs.starship
    pkgs.fastfetch pkgs.gammastep

    # unsorted
    pkgs.kdePackages.systemsettings pkgs.ayugram-desktop pkgs.vicinae pkgs.nix-diff
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default pkgs.lightdm
  ];

  imports = map
    (name: enabledModules.${name})
    (builtins.attrNames enabledModules);
}
