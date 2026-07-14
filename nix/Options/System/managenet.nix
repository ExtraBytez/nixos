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
  options.managenet.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Manage NetworkManager profiles automatically";
  };

  config = lib.mkIf config.managenet.enable {
  };
}
