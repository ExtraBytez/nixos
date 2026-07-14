# nix/home-modules/hello.nix
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
  Username =
    (lib.toUpper (lib.substring 0 1 username)) + (lib.substring 1 (lib.stringLength username) username);
  cfg = config.windowmanager;
  # ᓚᘏᗢ
  displayName = if config.japanese.enable && Username == "Nate" then "ネイト" else Username;
  greeting = if config.japanese.enable then "こんにちは${displayName}さん" else "Hello ${displayName}";
  passwordprompt = if config.japanese.enable then "パスワード。。。" else "Password...";
in
{
  options.windowmanager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Hyprland Window Manager";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprshot = {
      enable = true;
      package = pkgs.hyprshot;
    };
    programs.hyprlock = {
      enable = true;
      package = pkgs.hyprlock;
      settings = {
        "$font" = "Monospace";
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
        };
        image = [
          {
            path = "/home/${env.username}/.config/nixos/data/icon.jpg";
            rounding = -1;
            position = "0, 150";
            border_color = "rgba(0, 255, 255, 1.0)";
          }
        ];
        label = [
          {
            text = "$TIME12";
            font_size = 20;
            font_family = "$font";
            position = "0, -30";
            halign = "center";
            valign = "center";
          }
          {
            text = greeting;
            font_size = 35;
            font_family = "$font";
            position = "0, 20";
            halign = "center";
            valign = "center";
          }
        ];
        animations = {
          enabled = true;
          fade_in = {
            duration = 300;
            bezier = "easeOutQuint";
          };
          fade_out = {
            duration = 300;
            bezier = "easeOutQuint";
          };
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3; # Increased from 1 (more passes = smoother blur)
            blur_size = 1; # Increased from 4 (default, larger blur radius)
            noise = 0.0117; # Default noise for texture
            contrast = 0.8916; # Default contrast modulation
            brightness = 0.8172; # Default brightness modulation
            vibrancy = 0.1696; # Adds color saturation to blur
            vibrancy_darkness = 0.0; # Adjust if dark areas look too vibrant
          }
        ];

        input-field = [
          {
            size = "400, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(0, 255, 255)";
            outline_thickness = 2;
            placeholder_text = "<span foreground=\"##cad3f5\">${passwordprompt}</span>";
            shadow_passes = 2;
          }
        ];
      };
    };
    home.packages = with pkgs; [
      hyprpicker
      alacritty
      nerd-fonts.jetbrains-mono
      bemoji
      hicolor-icon-theme
    ];
    home.file = {
      ".config/cava/config".text = ''
        [color]
        background = '#1e1e2e'

        gradient = 1

        gradient_color_1 = '#94e2d5'
        gradient_color_2 = '#89dceb'
        gradient_color_3 = '#74c7ec'
        gradient_color_4 = '#89b4fa'
        gradient_color_5 = '#cba6f7'
        gradient_color_6 = '#f5c2e7'
        gradient_color_7 = '#eba0ac'
        gradient_color_8 = '#f38ba8'
      '';
    };
  };
}
