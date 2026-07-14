# nix/home-modules/hello.nix
{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;

  cfg = config.qemu;
in
{
  options.qemu = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "QEMU Support";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.virt-manager ];
    xdg.desktopEntries = {
      virt-manager = {
        name = "Virtual";
        icon = "virt-manager";
        exec = "virt-manager";
        categories = [ "System" ];
      };
    };
  };
}
