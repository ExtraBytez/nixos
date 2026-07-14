# nix/home-modules/hello.nix
{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;

  cfg = config.hello;
in
{
  options.hello = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Hello World";
    };
  };

  config = lib.mkIf cfg.enable {
  };
}
