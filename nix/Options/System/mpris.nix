{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.mpris;
  username = env.username;
in
{
  options.mpris.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Mprisence Setup";
  };

  config = lib.mkIf config.mpris.enable {
    environment.systemPackages = [ pkgs.mprisence ];
    home-manager.users.${username}.mpris.enable = true;

  };
}
