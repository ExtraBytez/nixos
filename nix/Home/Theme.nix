{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.pointerCursor = lib.mkIf config.windowmanager.enable {
    package = pkgs.catppuccin-cursors.mochaRed;
    enable = true;
    name = "catppuccin-mocha-red-cursors";
    size = 24;
    gtk.enable = true;
  };
  gtk = lib.mkIf config.windowmanager.enable {
    gtk4.theme = null;
    colorScheme = "dark";
    enable = true;
    theme = {
      name = "Catppuccin";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Candy";
      package = pkgs.candy-icons;
    };
  };
  qt = lib.mkIf config.windowmanager.enable {
    enable = true;
  };
}
