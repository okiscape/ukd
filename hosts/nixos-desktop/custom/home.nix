{pkgs, inputs, ...}:
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

  imports = [
    inputs.konawalls.homeManagerModules.default

    ./configs/driftwm.nix
    ./configs/kitty.nix
    ./configs/starship.nix
    ./configs/fish.nix
    ./configs/fastfetch.nix
    ./configs/konawalls.nix
  ];
}
