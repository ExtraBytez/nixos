{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.entertainment;
  username = env.username;
in
{
  options.entertainment.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Entertainment";
  };

  config = lib.mkIf config.entertainment.enable {
    home-manager.users.${username}.entertainment.enable = true;
  };
}
