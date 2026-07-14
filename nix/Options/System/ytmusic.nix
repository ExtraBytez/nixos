{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.ytmusic;
  username = env.username;
in
{
  options.ytmusic.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Youtube Music";
  };

  config = lib.mkIf config.ytmusic.enable {
    home-manager.users.${username}.ytmusic.enable = true;
  };
}
