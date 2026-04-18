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
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;

  cfg = config.opensnitch;
in
{
  options.opensnitch = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Opensnitch packet firewall";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      opensnitch-ui
    ];
    xdg.desktopEntries = {
      opensnitch_ui = {
        name = "Snitch";
        icon = "firewall-config";
        exec = "opensnitch-ui";
        categories = [ "System" ];
      };
    };
    wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter [
      "opensnitch-ui"
    ];
  };
}
