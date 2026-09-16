{
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        source = ../../../../common/fastfetch-logo.png;
        height = 12;
        width = 36;
        padding = {
          right = 5;
          left = 5;
          top = 2;
        };
      };

      display = {
        separator = "  ";
        disableLinewrap = true;
        color = {
          keys = "reset_light_white";
        };
        key = {
          width = 10;
          type = "string";
        };
      };

      modules = [
        {
          type = "title";
          format = "> fastfetch of the {host-name}";
        }
        "break"
        {
          type = "os";
          key = "os";
          format = "{2}";
        }
        {
          type = "packages";
          key = "pkgs";
          format = "{all}";
        }
        {
          type = "shell";
          key = "sh";
        }
        {
          type = "terminal";
          key = "term";
        }
        {
          type = "uptime";
          key = "uptime";
        }
        {
          type = "wm";
          key = "wm";
          format = "{1} - {3}";
        }
        "break"
        {
          type = "cpu";
          format = "{1}";
          key = "cpu";
        }
        {
          type = "gpu";
          format = "{1} {2}";
          key = "gpu";
        }
        {
          type = "memory";
          key = "ram";
          format = "{2}";
        }
        {
          type = "display";
          key = "display";
          format = "{1}x{2}@{3}Hz {12} inches";
        }
        {
          type = "battery";
          key = "battery";
          format = "{capacity} {status} - {cycle-count} cycles";
          percent = {
            type = 1;
          };
        }
        {
          type = "disk";
          key = "disk";
          format = "{size-total}";
        }
        {
          type = "board";
          key = "board";
          format = "{vendor} {name}";
        }
      ];
    };
  };
}
