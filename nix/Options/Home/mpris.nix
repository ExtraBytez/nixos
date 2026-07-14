# nix/home-modules/hello.nix
{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;
  template = builtins.readFile ../../../data/mprisence/config.toml;
  filled = builtins.replaceStrings [ "@imgbb_api_key@" ] [ env.imgbb ] template;
  mprisenceConfig = pkgs.writeTextFile {
    name = "mprisence-config.toml";
    text = filled;
  };
  cfg = config.mpris;
in
{
  options.mpris = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "MPRIS Setup";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter [ "mprisence" ];
    home.file.".config/mprisence/config.toml".source = mprisenceConfig;
    programs.zed-editor.userSettings.lsp.discord_presence = {
      initialization_options = {
        application_id = "1263505205522337886";

        state = "Working on {filename}";
        details = "In {workspace}";

        large_image = "https://raw.githubusercontent.com/xhyrom/zed-discord-presence/main/assets/icons/{language:lo}.png";
        large_text = "{language:u}";

        small_image = "https://raw.githubusercontent.com/xhyrom/zed-discord-presence/main/assets/icons/zed.png";
        small_text = "Zed";
        idle = {
          timeout = 300;
          action = "change_activity";

          state = "Idling";
          details = "In Zed";
          large_image = "https://raw.githubusercontent.com/xhyrom/zed-discord-presence/main/assets/icons/zed.png";
          large_text = "Zed";
          small_image = "https://raw.githubusercontent.com/xhyrom/zed-discord-presence/main/assets/icons/idle.png";
          small_text = "Idle";
        };

        rules = {
          mode = "blacklist";
          paths = [ "absolute path" ];
        };

        git_integration = true;

        languages = {
          rust = {
            state = "Hacking on {filename}";
            details = "Rustacean at work";
          };
        };
      };
    };
  };
}
