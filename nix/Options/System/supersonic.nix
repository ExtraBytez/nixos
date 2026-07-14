{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.supersonic;
  username = env.username;
in
{
  options.supersonic.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Supersonic Media Player";
  };

  config = lib.mkIf config.supersonic.enable {
    home-manager.users.${username}.supersonic.enable = true;
  };
}
