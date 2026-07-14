{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.opensnitch;
  username = env.username;
in
{
  options.opensnitch.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Opensnitch packet firewall";
  };

  config = lib.mkIf config.opensnitch.enable {
    services.opensnitch.enable = true;
    networking.firewall.allowedTCPPorts = lib.mkAfter [ 53317 ];
    networking.firewall.allowedUDPPorts = lib.mkAfter [ 53317 ];
    home-manager.users.${username}.opensnitch.enable = true;
  };
}
