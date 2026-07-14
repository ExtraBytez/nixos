{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.streaming;
  username = env.username;
in
{
  options.streaming.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Streaming";
  };

  config = lib.mkIf config.streaming.enable {
    home-manager.users.${username}.streaming.enable = true;
  };
}
