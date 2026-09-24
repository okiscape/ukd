{

  xdg.configFile."konawalls/config.json".source =
    ../../../../common/konawalls/config.json;

  users.groups.wallpapers = {};

  systemd.tmpfiles.rules = [
    "d   /var/lib/wallpapers              0775  root     wallpapers -"
    "f   /var/lib/wallpapers/wallpaper.png 0664  root     wallpapers - -"
  ];
}
