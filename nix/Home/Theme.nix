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
    theme = {
      name = "Catppuccin";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Candy";
      package = pkgs.candy-icons;
    };
  };
  # For Qt applications (optional but recommended)
  qt = lib.mkIf config.windowmanager.enable {
    enable = true;
  };
}
