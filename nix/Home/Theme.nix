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
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "Catppuccin-GTK-Red-Dark";
      package = pkgs.magnetic-catppuccin-gtk.override {
        accent = [ "red" ];
        shade = "dark";
      };
    };
    iconTheme = {
      name = "candy-icons";
      package = pkgs.candy-icons;
    };

    gtk4.theme = null;
  };
}
