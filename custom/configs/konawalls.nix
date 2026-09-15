{inputs, pkgs,...}:
{
  programs.konawalls = {
    enable = true;
    package = inputs.konawalls.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      tags = ["blue_archive" "s"];
      savePath = "/home/okiscape/.config/konawalls/wallpaper.img";
      executeAfter = "awww img /home/okiscape/.config/konawalls/wallpaper.img";
    };
  };
}
