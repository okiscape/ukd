{
  xdg.configFile."hellwal/templates".source =
    ../../../../common/hellwal;

  systemd.user.tmpfiles.rules = [
    "d %h/.cache/hellwal/cache 0755 - - -"
  ];
}
