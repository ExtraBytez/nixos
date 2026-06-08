{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.pointerCursor = lib.mkIf config.windowmanager.enable {
    package = pkgs.catppuccin-cursors.mochaRed;
    name = "catppuccin-mocha-red-cursors";
    size = 24;
    gtk.enable = true;
  };
  gtk = {
    enable = true;
    gtk4.theme = null;
    colorScheme = "dark";
    theme = {
      name = "Sweet";
      package = pkgs.sweet;
    };
    iconTheme = {
      name = "Candy";
      package = pkgs.candy-icons;
    };
  };
  # For Qt applications (optional but recommended)
  qt = {
    enable = true;
    platformTheme.name = "gtk"; # Makes Qt apps follow GTK theme
  };
}
