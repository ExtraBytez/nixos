{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.gui;
  username = env.username;
in
{
  options.gui.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "GUI Settings (mostly) applications";
  };

  config = lib.mkIf config.gui.enable {
    home-manager.users.${username}.gui.enable = true;

  };
}
