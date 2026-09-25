{
  programs.kitty = {
    enable = true;
    font = {
      name = "Geist Mono";
      size = 10;
    };
    settings = {
      shell = "fish";
      confirm_os_wihdow_close = 0;
      cursor_shape = "beam";
      cursor_shape_unfocused = "underline";
      copy_on_select = true;
      window_margin_width = 8;
      include = "~/.cache/hellwal/kitty.conf";
    };
  };
}
