{
  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };

  networking.proxy = {
    default = "http://127.0.0.1:2080";
    noProxy = "127.0.0.1,localhost,::1";
  };
}
