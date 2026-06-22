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
  options.editor.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables ZED";
  };

  config = lib.mkIf config.editor.enable {
    home-manager.users.${username}.editor.enable = true;
  };
}
