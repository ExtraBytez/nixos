{ lib, config, ... }:
let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/Generated/env.nix;
in
{
  xdg = lib.mkIf config.windowmanager.enable {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "librewolf.desktop" ];
        "x-scheme-handler/http" = [ "librewolf.desktop" ];
        "x-scheme-handler/https" = [ "librewolf.desktop" ];
        "x-scheme-handler/about" = [ "librewolf.desktop" ];
        "x-scheme-handler/unknown" = [ "librewolf.desktop" ];
      };
    };
    userDirs = {
      createDirectories = false;
      desktop = /home/${env.username};
      download = /home/${env.username};
      templates = /home/${env.username};
      publicShare = /home/${env.username};
      documents = /home/${env.username};
      music = /home/${env.username};
      pictures = /home/${env.username};
      videos = /home/${env.username};
    };
    desktopEntries = lib.mkIf config.windowmanager.enable {
      "com.cloudflare.WarpTaskbar" = {
        name = "Warp";
        exec = "warp-taskbar";
        noDisplay = true;
        categories = [ "Network" ];
      };
      "dev.noctalia.Noctalia" = {
        name = "Noctalia";
        exec = "noctalia";
        noDisplay = true;
        categories = ["System"];
      };
      nixos-manual = {
        name = "Nixos Manual";
        exec = "nixos-help";
        noDisplay = true;
        categories = [ "System" ];
      };
      htop = {
        name = "htop";
        exec = "alacritty -e htop";
        noDisplay = true;
        categories = [ "System" ];
      };
      Alacritty = {
        name = "alacritty";
        exec = "alacritty";
        noDisplay = true;
        categories = [ "System" ];
      };
      "librewolf" = {
        name = "Browser";
        icon = "librewolf";
        exec = "librewolf";
        categories = [ "Network" ];
      };
    };
  };
}
