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
    x11.enable = true;
  };
  gtk = lib.mkIf config.windowmanager.enable {
    enable = true;
    gtk4.theme = null;
    theme = {
      name = "catppuccin-mocha-red-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "red" ];
        variant = "mocha";
      };
    };
    iconTheme = lib.mkIf config.windowmanager.enable {
      name = "candy-icons";
      package = pkgs.candy-icons;
    };
    gtk3.extraConfig = lib.mkIf config.windowmanager.enable {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = lib.mkIf config.windowmanager.enable {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  home.sessionVariables = lib.mkIf config.windowmanager.enable {
    XCURSOR_SIZE = "24";
    GTK_THEME = "catppuccin-mocha-red-standard";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    QML_IMPORT_PATH = "${pkgs.quickshell}/lib/qml";
    QML2_IMPORT_PATH = "${pkgs.quickshell}/lib/qml";
    EDITOR = "nvim";
    GTK_USE_PORTAL = "1";
  };
  dconf.settings = lib.mkIf config.windowmanager.enable {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "catppuccin-mocha-red-standard";
      icon-theme = "candy-icons";
      cursor-theme = "catppuccin-mocha-red-cursors";
    };
    "io/github/Foldex/AdwSteamGtk" = {
      "color-theme-options" = "Catppuccin-Mocha";
      "hide-whats-new-switch" = "false";
      "library-sidebar-options" = "Show";
      "login-qr-options" = "Show";
      "no-rounded-corners-switch" = "false";
      "prefs-beta-support" = "false";
      "window-controls-layout-options" = "Auto";
      "window-controls-options" = "Adwaita";
    };
  };
}
