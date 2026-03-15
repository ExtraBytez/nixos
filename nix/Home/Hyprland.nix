{ lib, config, ... }:
let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
in
{
  wayland.windowManager.hyprland = lib.mkIf config.windowmanager.enable {
    enable = true;
    settings = {
      monitor = ", preferred, auto, 1";
      bezier = "springy, 0.13, 0.99, 0.29, 1.1";
      general = {
        layout = "dwindle";
        gaps_in = 5;
        gaps_out = 10;
        border_size = 3;
        "col.active_border" =
          "rgba(ff0000ff) rgba(ffff00ff) rgba(00ff00ff) rgba(00ffffff) rgba(0000ffff) rgba(ff00ffff) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };
      decoration = {
        rounding = 10;
        fullscreen_opacity = 1;
        blur = {
          enabled = true;
          size = 3;
          passes = 3;
        };

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };
      animation = [
        "windowsIn, 1, 7, springy, popin 90%"
        "windowsOut, 1, 7, springy, popin 90%"
        "windowsMove, 1, 7, springy, slide"
        "workspaces, 1, 7, springy, slidevert"
        "fade, 1, 7, springy"
      ];
      layerrule = [
        "blur on, match:namespace waybar"
        "ignore_alpha 0, match:namespace waybar"
      ];
      windowrule = [
        "no_blur on, match:class ^(osu!)$"
        "opacity 0.70 0.70, match:focus 0"
        "opacity 0.90 0.90, match:focus 1"
        "opacity 0.95 0.95, match:class ^(Alacritty)$"
        "opacity 0.70 0.70, match:class ^(Alacritty)$, match:focus 0"
        "maximize on, match:class ^(Alacritty)$"
      ];
      exec-once = [
        "waybar"
        "awww-daemon"
        "polkit-gnome-authentication-agent-1"
        "mako"
      ]
      ++ lib.optionals config.japanese.enable [
        "fcitx5"
      ]
      ++ lib.optionals config.supersonic.enable [
        "supersonic -start-minimized"
      ];
      input = {
        natural_scroll = false;
      };
      "$mod" = "SUPER";
      binds = {
        drag_threshold = 10;
      };
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bind = [
        ", Print, exec, hyprshot -m region"
        "ALT, Print, exec, hyprshot -m window"
        "$mod, Print, exec, hyprshot -m output"
        "$mod ALT, F, exec, zsh ~/.config/nixos/data/hyprland/fullscreen_trans.zsh"
        "$mod, W, exec, zsh ~/.config/nixos/scripts/switchwall.zsh"
        "$mod SHIFT, period, movewindow, r"
        "$mod SHIFT, comma, movewindow, l"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        "$mod, PERIOD, exec, hyprpicker | wl-copy"
        "$mod, SPACE, exec, bemoji"
        "$mod, COMMA, exec, bash ~/.config/nixos/data/hyprland/bluetooth.sh"
        "$mod ALT, COMMA, exec, alacritty -e bluetoothctl"
        "$mod, T, exec, alacritty"
        "$mod, D, exec, fuzzel"
        "$mod, Z, exec, zeditor"
        "$mod, B, exec, librewolf"
        "$mod, S, exec, supersonic"
        "$mod ALT, L, exec, hyprlock"
        "$mod ALT, E, exit"
        "$mod, Q, killactive"
        "$mod CTRL, Q, forcekillactive"
        "$mod, F, fullscreenstate, 1"
        "$mod SHIFT, F, fullscreenstate, 2"
        "$mod, V, togglefloating"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod, R, submap, resize"
      ];
      binde = [
        "$mod, up, exec, zsh /home/${env.username}/.config/nixos/data/hyprland/workspaces.zsh --input=up"
        "$mod, down, exec, zsh /home/${env.username}/.config/nixos/data/hyprland/workspaces.zsh --input=down"
      ];
      bindle = [
        "Ctrl, XF86AudioPlay, exec, playerctl previous"
        "Shift, XF86AudioPlay, exec, playerctl next"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
        "Shift, XF86MonBrightnessUp, exec, brightnessctl set +5%"
        "Shift, XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        "Ctrl, XF86MonBrightnessUp, exec, brightnessctl set +1%"
        "Ctrl, XF86MonBrightnessDown, exec, brightnessctl set 1%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"
        "Shift, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+"
        "Shift, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"
        "Ctrl, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01+"
        "Ctrl, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
      misc = [
        { "disable_splash_rendering" = true; }
        { "disable_hyprland_logo" = true; }
      ];
    };
    extraConfig = ''
      submap = resize
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10
      binde = SHIFT, right, resizeactive, 50 0
      binde = SHIFT, left, resizeactive, -50 0
      binde = SHIFT, up, resizeactive, 0 -50
      binde = SHIFT, down, resizeactive, 0 50
      bind = , escape, submap, reset
      bind = , Return, submap, reset
      submap = reset
    '';
  };
}
