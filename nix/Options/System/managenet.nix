{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.managenet;
  username = env.username;
in
{
  options.managenet.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Manage NetworkManager profiles automatically";
  };

  config = lib.mkIf config.managenet.enable {
  };
}
