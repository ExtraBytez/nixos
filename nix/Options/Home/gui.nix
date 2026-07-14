# nix/home-modules/hello.nix
{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;

  cfg = config.gui;
in
{
  options.gui = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "GUI Settings (mostly) applications";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bind = lib.mkAfter [ "$mod, E, exec, nautilus" ];
    home.packages = [
      pkgs.pavucontrol
      pkgs.mpv
      pkgs.gnome-clocks
      pkgs.networkmanagerapplet
    ];
    xdg.desktopEntries = {
      nm-connection-editor = {
        name = "Network";
        noDisplay = true;
        icon = "cs-network";
        exec = "nm-connection-editor";
        categories = [ "Settings" ];
      };
      "org.gnome.clocks" = {
        name = "Time";
        icon = "preferences-system-time";
        exec = "gnome-clocks";
        categories = [ "Utility" ];
      };
      "mpv" = {
        name = "Player";
        noDisplay = true;
        icon = "mpv";
        exec = "mpv";
        categories = [ "AudioVideo" ];
      };
      "org.pulseaudio.pavucontrol" = {
        name = "Audio";
        noDisplay = true;
        icon = "yast-sound";
        exec = "pavucontrol";
        categories = [ "AudioVideo" ];
      };
    };
  };
}
