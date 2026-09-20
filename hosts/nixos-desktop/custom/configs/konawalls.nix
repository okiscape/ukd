{inputs, pkgs,...}:
{
  programs.konawalls = {
    enable = true;
    package = inputs.konawalls.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      tags = ["blue_archive" "s"];
      savePath = "/var/lib/wallpapers/wallpaper.png";
      executeAfter = "awww img /var/lib/wallpapers/wallpaper.png";
    };
  };
}
