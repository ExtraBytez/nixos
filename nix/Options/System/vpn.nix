{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.vpn;
  username = env.username;
in
{
  options.vpn.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable ProtonVPN supportt.";
  };

  config = lib.mkIf config.vpn.enable {
    home-manager.users.${username}.vpn.enable = true;
  };
}
