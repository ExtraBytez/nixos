{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.ssh;
  username = env.username;
in
{
  options.ssh.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "SSH Usage";
  };

  config = lib.mkIf config.ssh.enable {
    networking.firewall.allowedTCPPorts = lib.mkAfter [ 22 ];
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
    };
  };
}
