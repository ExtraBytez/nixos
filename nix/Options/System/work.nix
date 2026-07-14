{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.work;
  username = env.username;
in
{
  options.work.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Apps needed for work for me";
  };

  config = lib.mkIf config.work.enable {
    home-manager.users.${username}.work.enable = true;
  };
}
