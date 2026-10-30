{
  config,
  lib,
  pkgs,
  ...
}:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/Generated/env.nix;
  username = env.username;

  cfg = config.ytmusic;
  limusic =
    let
      pname = "limusic";
      version = "1.3.0";
      src = pkgs.fetchurl {
        url = "https://github.com/SimoHypers/limusic/releases/download/v1.3.0/limusic_1.3.0_amd64.AppImage";
        hash = "sha256-skhW7OeTMN06Y/WvI5Tm+Dja50rtxh42d0Q96Qwrc4c=";
      };
    in
    pkgs.appimageTools.wrapType2 {
      inherit pname version src;

      extraPkgs = pkgs: [
        pkgs.libgpg-error
      ];
    };
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
    home.packages = [ limusic ];

    xdg.desktopEntries = {
      "Limusc" = {
        name = "YTMusic";
        exec = "limusic";
        icon = "youtube-music";
        categories = [ "Network" ];
      };
    };
  };
}
