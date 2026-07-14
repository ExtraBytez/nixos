{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;

  cfg = config.entertainment;
in
{
  options.entertainment = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Entertainment.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.freetube = {
      enable = true;
      settings = {
        allowDashAv1Formats = true;
        checkForUpdates = true;
        defaultQuality = "1080";
        baseTheme = "catppuccinMocha";
        useSponsorBlock = true;
        hideTrendingVideos = true;
        hidePopularVideos = true;
        hidePlaylists = true;
        hideSubscriptionShorts = true;
        hideChannelShorts = true;
        hideChannelPodcasts = true;
        hideFeaturedChannels = true;
        useRssFeeds = true;
        hideWatchedSubs = true;
        defaultViewingMode = "default";
        enableSubtitlesByDefault = true;
        mainColor = "CatppuccinMochaRed";
        secColor = "DraculaRed";
      };
    };
  };
}
