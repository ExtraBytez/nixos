{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.airdrop;
  username = env.username;
in
{
  options.airdrop.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "AirDrop Support";
  };

  config = lib.mkIf config.airdrop.enable {
    home-manager.users.${username}.airdrop.enable = true;
  };
}
