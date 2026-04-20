{
  config,
  lib,
  ...
}:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;
in
{
  options.jelly.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Jellyfin support.";
  };

  config = lib.mkIf config.jelly.enable {
    home-manager.users.${username}.jelly.enable = true;
  };
}
