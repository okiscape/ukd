{
  programs.fish = {
    enable = true;
    shellInit = "source ${../../../../common/fish_init.sh}";
  };

  xdg.configFile."fish/functions/".source =
    ../../../../common/fish_functions/;
}
