{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;

  cfg = config.development;
in
{
  options.development = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Development.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      yt-dlp
      id3v2
      pkgs-stable.godot
    ];
    xdg.desktopEntries = {
      "org.godotengine.Godot4.4" = {
        name = "GameDev";
        icon = "godot";
        exec = "godot";
        categories = [ "Development" ];
      };
      github = {
        name = "Storage";
        exec = "";
        icon = "github-desktop";
        categories = [ "Development" ];
        noDisplay = true;
      };
    };
  };
}
