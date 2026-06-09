{
  config,
  lib,
  pkgs,
  ...
}:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;

  cfg = config.chat;
in
{
  options.chat = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable chat applications";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.element-desktop.enable = true;
    xdg.desktopEntries = {
      "element-desktop" = {
        name = "Chat";
        exec = "element-desktop";
        icon = "element-desktop";
        categories = [ "Chat" ];
      };
    };
    #DISCORD DEPRECATED
    #programs.vesktop.enable = true;
    #xdg.desktopEntries = {
    # vesktop = {
    #  name = "Chat";
    # exec = "zsh /home/${username}/.config/nixos/data/vesktop/chatlock.zsh";
    #icon = "vesktop";
    #categories = [ "Chat" ];
    #};
    #};
    #home.file = {
    # ".config/vesktop/settings.json" = {
    #  source = ../../../data/vesktop/settings-discord.json;
    #};
    #".config/vesktop/settings/settings.json" = {
    # source = ../../../data/vesktop/settings-vencord.json;
    #};
    #".config/vesktop/settings/quickCss.css" = {
    # source = ../../../data/vesktop/quickCss.css;
    #};
    #".config/vesktop/userAssets" = {
    #  source = ../../../data/vesktop/userAssets;
    #  recursive = true;
    #};
    #};
  };
}
