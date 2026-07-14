{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.jelly;
  username = env.username;
in
{
  options.jelly.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Jellyfin support.";
  };

  config = lib.mkIf config.jelly.enable {
    home-manager.users.${username}.jelly.enable = true;
  };
}
