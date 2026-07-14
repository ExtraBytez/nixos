# nix/home-modules/work.nix
{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;

  cfg = config.work;
in
{
  options.work = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Apps i need for work";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.obsidian
      #pkgs.slack Deprecated
      pkgs.koodo-reader
      pkgs.ungoogled-chromium
      pkgs.inkscape
    ];
    xdg.desktopEntries = {
      #slack = {
      # name = "Work";
      #exec = "slack";
      #icon = "slack";
      #};
      obsidian = {
        name = "Markdown";
        exec = "obsidian";
        icon = "obsidian";
      };
      "chromium-browser" = {
        name = "ExBrowser";
        exec = "chromium";
        icon = "chromium";
      };
      "koodo-reader" = {
        name = "EReader";
        exec = "koodo-reader";
        icon = "accessories-ebook-reader";
      };
      "org.inkscape.Inkscape" = {
        name = "Marking";
        exec = "inkscape";
        icon = "inkscape";
      };
    };
  };
}
