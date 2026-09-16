{
  programs.fish = {
    enable = true;
    shellInit = "source ${../scripts/fish_init.sh}";
  };
}
