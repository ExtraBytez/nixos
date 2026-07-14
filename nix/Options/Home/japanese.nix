# nix/home-modules/hello.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/Generated/env.nix;
  username = env.username;

  cfg = config.japanese;
in
{
  options.japanese = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable japanese typing and fonts";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries = {

      "fcitx5-configtool" = {
        name = "Fcitx5 Config Tool";
        exec = "fcitx5-configtool";
        type = "Application";
        noDisplay = true;
      };

      "fcitx5-wayland-launcher" = {
        name = "Fcitx5 Wayland Launcher";
        exec = "fcitx5-wayland-launcher";
        type = "Application";
        noDisplay = true;
      };

      "kcm_fcitx5" = {
        name = "Fcitx5 KDE Control Module";
        exec = "kcmshell5 kcm_fcitx5";
        type = "Application";
        noDisplay = true;
      };

      "org.fcitx.Fcitx5" = {
        name = "Fcitx5";
        exec = "fcitx5";
        type = "Application";
        noDisplay = true;
      };

      "org.fcitx.fcitx5-migrator" = {
        name = "Fcitx5 Migrator";
        exec = "fcitx5-migrator";
        type = "Application";
        noDisplay = true;
      };

      "org.fcitx.fcitx5-qt5-gui-wrapper" = {
        name = "Fcitx5 Qt5 GUI Wrapper";
        exec = "fcitx5-qt5-gui-wrapper";
        type = "Application";
        noDisplay = true;
      };

      "org.fcitx.fcitx5-config-qt" = {
        name = "Fcitx5 Qt Config";
        exec = "fcitx5-config-qt";
        type = "Application";
        noDisplay = true;
      };

      "org.fcitx.fcitx5-qt6-gui-wrapper" = {
        name = "Fcitx5 Qt6 GUI Wrapper";
        exec = "fcitx5-qt6-gui-wrapper";
        type = "Application";
        noDisplay = true;
      };
      "kbd-layout-viewer5" = {
        name = "Keyboard Layout Viewer";
        exec = "kbd-layout-viewer5";
        type = "Application";
        noDisplay = true;
      };
    };
  };
}
