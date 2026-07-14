# nix/home-modules/hello.nix
{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;

  cfg = config.airdrop;
in
{
  options.airdrop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "AirDrop";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter [ "localsend_app --hidden" ];
    home.packages = [ pkgs.localsend ];
    xdg.desktopEntries = {
      "LocalSend" = {
        name = "AirDrop";
        icon = "localsend";
        exec = "localsend_app";
        categories = [ "Network" ];
      };
    };
  };
}
