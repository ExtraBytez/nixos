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
  options.ytmusic.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Youtube Music";
  };

  config = lib.mkIf config.ytmusic.enable {
    home-manager.users.${username}.ytmusic.enable = true;
  };
}
