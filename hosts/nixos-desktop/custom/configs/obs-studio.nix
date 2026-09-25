{ pkgs, ... }:

{
  programs.obs-studio.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  xdg.portal = {
    enable = true;

    wlr.enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  security.rtkit.enable = true;
}
