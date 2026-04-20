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

  cfg = config.jelly;
in
{
  options.jelly = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Jellyfin Player";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.fladder ];
    xdg.desktopEntries = {
      "fladder" = {
        name = "Jellyfin";
        icon = "jellyfin";
        exec = "Fladder";
        categories = [ "Network" ];
      };
    };
  };
}
