{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.development;
  username = env.username;
in
{
  options.development.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Development.";
  };

  config = lib.mkIf config.development.enable {
    environment.systemPackages = with pkgs; [
      docker
      docker-compose
      gcc
    ];
    virtualisation.docker.enable = true;
    home-manager.users.${username}.development.enable = true;
  };
}
