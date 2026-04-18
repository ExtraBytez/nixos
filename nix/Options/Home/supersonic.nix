# nix/home-modules/supersonic.nix
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
  template = builtins.readFile ../../../data/supersonic/config.toml;
  replacements = {
    "@USERNAME@" = env.username;
    "@SERVER_IP@" = env.server;
  };
  filled =
    pkgs.lib.replaceStrings (builtins.attrNames replacements) (builtins.attrValues replacements)
      template;
  Config = pkgs.writeText "supersonic_config.toml" filled;
  cfg = config.supersonic;
in
{
  options.supersonic = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Supersonic Media Player Support";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries.supersonic-wayland = {
      name = "Music";
      icon = "juk";
      exec = "supersonic-wayland";
      categories = [ "AudioVideo" ];
    };
    xdg.desktopEntries.supersonic = {
      name = "Music";
      icon = "juk";
      exec = "supersonic";
      categories = [ "AudioVideo" ];
      noDisplay = true;
    };
    home.packages = [ pkgs.supersonic-wayland ];
    home.file = {
      ".config/supersonic/themes/theme.toml" = {
        source = ../../../data/supersonic/theme.toml;
      };
      ".config/supersonic/config.toml" = {
        source = Config;
      };
    };
  };
}
