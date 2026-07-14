# nix/home-modules/hello.nix
{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;

  cfg = config.drawing;
in
{
  options.drawing = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Drawing Tablet";
    };
  };

  config = lib.mkIf cfg.enable {
  };
}
