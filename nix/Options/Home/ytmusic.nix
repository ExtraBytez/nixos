# nix/home-modules/ytmusic.nix
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

  cfg = config.ytmusic;
in
{
  options.ytmusic = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "YouTube Music Support";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.pear-desktop ];
    home.activation.ytmusicConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/YouTube Music"
      cp -f ${../../../data/ytmusic/config.json} \
        "$HOME/.config/YouTube Music/config.json"
      sed -i -e "s|@YT_THEME@|/home/${username}/.config/nixos/data/ytmusic/mocha.css|g" "$HOME/.config/YouTube Music/config.json"
    '';

    xdg.desktopEntries = {
      "com.github.th_ch.youtube_music" = {
        name = "YTMusic";
        exec = "zsh /home/${username}/.config/nixos/data/ytmusic/musiclock.zsh";
        icon = "youtube-music";
        categories = [ "Network" ];
      };
    };
  };
}
