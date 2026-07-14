{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jelly;
in
{
  options.jelly = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Jellyfin Player";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.fladder ];
    xdg.desktopEntries = {
      "fladder" = {
        name = "Jellyfin";
        icon = "jellyfin";
        exec = "Fladder";
        categories = [ "Network" ];
      };
    };
  };
}
