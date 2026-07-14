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
  options.airdrop.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "AirDrop Support";
  };

  config = lib.mkIf config.airdrop.enable {
    home-manager.users.${username}.airdrop.enable = true;
  };
}
