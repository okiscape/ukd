{
  xdg.configFile."hellwal/templates/colors.json".source =
    ../../../../common/hellwal/colors.json;

  systemd.user.tmpfiles.rules = [
    "d %h/.cache/hellwal/cache 0755 - - -"
  ];
}
