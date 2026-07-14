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
  options.hello.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Hello World";
  };

  config = lib.mkIf config.hello.enable {
    home-manager.users.${username}.hello.enable = true;
  };
}
