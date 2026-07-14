{
  config,
  lib,
  ...
}:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/Generated/env.nix;
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
