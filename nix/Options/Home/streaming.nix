# nix/home-modules/hello.nix
{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;

  cfg = config.streaming;
in
{
  options.streaming = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Streaming";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.obs-studio
    ];
    xdg.desktopEntries = {
      "com.obsproject.Studio" = {
        name = "Record";
        icon = "obs";
        exec = "obs";
        categories = [ "AudioVideo" ];
      };
    };
  };
}
