{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
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
      pkgs-stable.rustfmt
      cruise
      docker
      docker-compose
      gcc
    ];
    virtualisation.docker.enable = true;
    home-manager.users.${username}.development.enable = true;
  };
}
