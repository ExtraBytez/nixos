{ lib, config, ... }:
let
  lua = lib.generators.mkLuaInline;

  # key string with the SUPER prefix: mod .. " + <keys>"
  withMod = keys: lua ''mod .. " + ${keys}"'';

  # hl.bind(keys, dispatcher[, opts])
  mkBindWith = opts: keys: dsp: {
    _args = [
      keys
      (lua dsp)
    ]
    ++ lib.optional (opts != { }) opts;
  };
  mkBind = mkBindWith { };

  exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';

  hold = mkBindWith {
    locked = true;
    repeating = true;
  };

  startup = [
    "noctalia"
    "warp-taskbar"
    "bitwarden"
  ]
  ++ lib.optional config.japanese.enable "fcitx5";
in
{
  wayland.windowManager.hyprland = lib.mkIf config.windowmanager.enable {
    enable = true;
    configType = "lua";

    settings = {
      mod._var = "SUPER";

      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = 1;
      };

      config = {
        cursor = {
          inactive_timeout = 0;
        };
        general = {
          layout = "dwindle";
          gaps_in = 5;
          gaps_out = 10;
          border_size = 3;
          col = {
            active_border = {
              colors = [
                "rgba(ff0000ff)"
                "rgba(ffff00ff)"
                "rgba(00ff00ff)"
                "rgba(00ffffff)"
                "rgba(0000ffff)"
                "rgba(ff00ffff)"
              ];
              angle = 45;
            };
            inactive_border = "rgba(595959aa)";
          };
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

        input.natural_scroll = false;
        binds.drag_threshold = 10;

        misc = {
          disable_splash_rendering = true;
          disable_hyprland_logo = true;
        };
      };

      curve = {
        _args = [
          "springy"
          {
            type = "bezier";
            points = [
              [
                0.13
                0.99
              ]
              [
                0.29
                1.1
              ]
            ];
          }
        ];
      };
      # Window Animations
      animation = [
        {
          leaf = "windowsIn";
          enabled = true;
          speed = 7;
          bezier = "springy";
          style = "popin 90%";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 7;
          bezier = "springy";
          style = "popin 90%";
        }
        {
          leaf = "windowsMove";
          enabled = true;
          speed = 7;
          bezier = "springy";
          style = "slide";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 7;
          bezier = "springy";
          style = "slidevert";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 7;
          bezier = "springy";
        }
      ];

      layer_rule = [
        {
          match.namespace = "waybar";
          blur = true;
          ignore_alpha = 0;
        }
      ];

      # Opacity rules
      window_rule = [
        {
          match.class = "^(osu!)$";
          no_blur = true;
        }
        {
          match.focus = false;
          opacity = "0.70 0.70";
        }
        {
          match.focus = true;
          opacity = "0.90 0.90";
        }
        {
          match.class = "^(Alacritty)$";
          opacity = "0.95 0.95";
        }
        {
          match = {
            class = "^(Alacritty)$";
            focus = false;
          };
          opacity = "0.70 0.70";
        }
        {
          match.class = "^(Alacritty)$";
          maximize = true;
        }
      ];
      #Startup apps
      on = [
        {
          _args = [
            "hyprland.start"
            (lua ''
              function()
                ${lib.concatMapStringsSep "\n  " (c: ''hl.exec_cmd("${c}")'') startup}
              end
            '')
          ];
        }
      ];
      #Binds
      bind = [
        # launchers / apps
        (mkBind (withMod "T") (exec "alacritty"))
        (mkBind (withMod "B") (exec "librewolf"))
        (mkBind (withMod "D") (exec "noctalia msg panel-open launcher"))
        (mkBind (withMod "SPACE") (exec "noctalia msg panel-open launcher /emo"))
        (mkBind (withMod "V") (exec "noctalia msg panel-open clipboard"))
        (mkBind (withMod "W") (exec "noctalia msg panel-open wallpaper"))
        (mkBind (withMod "ALT + W") (exec "noctalia msg panel-toggle noctalia/wallhaven:browser"))

        # control center / session
        (mkBind (withMod "A") (exec "noctalia msg panel-open control-center"))
        (mkBind (withMod "COMMA") (exec "noctalia msg panel-open control-center bluetooth"))
        (mkBind (withMod "M") (exec "noctalia msg panel-open control-center media"))
        (mkBind (withMod "O") (exec "noctalia msg settings-toggle"))
        (mkBind (withMod "L") (exec "noctalia msg session lock"))
        (mkBind (withMod "ALT + L") (exec "noctalia msg panel-open session"))
        (mkBind (withMod "ALT + E") "hl.dsp.exit()")

        # screenshots / picker
        (mkBind "Print" (exec "hyprshot -m region"))
        (mkBind "ALT + Print" (exec "hyprshot -m window"))
        (mkBind (withMod "Print") (exec "hyprshot -m output"))
        (mkBind (withMod "PERIOD") (exec "hyprpicker | wl-copy"))

        # window management
        (mkBind (withMod "Q") "hl.dsp.window.close()")
        (mkBind (withMod "CTRL + Q") "hl.dsp.window.kill()")
        (mkBind (withMod "F") ''hl.dsp.window.fullscreen_state({ internal = 1, client = -1, action = "toggle" })'')
        (mkBind (withMod "SHIFT + F") ''hl.dsp.window.fullscreen_state({ internal = 2, client = -1, action = "toggle" })'')
        (mkBind (withMod "ALT + F") (exec "zsh ~/.config/nixos/data/hyprland/fullscreen_trans.zsh"))
        (mkBind (withMod "SHIFT + V") ''hl.dsp.window.float({ action = "toggle" })'')
        (mkBind (withMod "SHIFT + PERIOD") ''hl.dsp.window.move({ direction = "r" })'')
        (mkBind (withMod "SHIFT + COMMA") ''hl.dsp.window.move({ direction = "l" })'')
        (mkBind (withMod "SHIFT + UP") ''hl.dsp.window.move({ direction = "u" })'')
        (mkBind (withMod "SHIFT + DOWN") ''hl.dsp.window.move({ direction = "d" })'')

        (mkBind (withMod "R") ''hl.dsp.submap("resize")'')

        # mouse
        (mkBindWith { mouse = true; } (withMod "mouse:272") "hl.dsp.window.drag()")
        (mkBindWith { mouse = true; } (withMod "mouse:273") "hl.dsp.window.resize()")

        # brightness
        (hold "XF86MonBrightnessUp" (exec "brightnessctl set +10%"))
        (hold "XF86MonBrightnessDown" (exec "brightnessctl set 10%-"))
        (hold "SHIFT + XF86MonBrightnessUp" (exec "brightnessctl set +5%"))
        (hold "SHIFT + XF86MonBrightnessDown" (exec "brightnessctl set 5%-"))
        (hold "CTRL + XF86MonBrightnessUp" (exec "brightnessctl set +1%"))
        (hold "CTRL + XF86MonBrightnessDown" (exec "brightnessctl set 1%-"))

        # volume
        (hold "XF86AudioRaiseVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+"))
        (hold "XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"))
        (hold "SHIFT + XF86AudioRaiseVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+"))
        (hold "SHIFT + XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"))
        (hold "CTRL + XF86AudioRaiseVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01+"))
        (hold "CTRL + XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01-"))
        (hold "XF86AudioMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
        (hold "XF86AudioMicMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
      ]
      ++ (
        # Workspace method
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = toString (i + 1);
            in
            [
              (mkBind (withMod "code:1${toString i}") "hl.dsp.focus({ workspace = ${ws} })")
              (mkBind (withMod "SHIFT + code:1${toString i}") "hl.dsp.window.move({ workspace = ${ws} })")
            ]
          ) 9
        )
      );
    };

    #ReSizer
    extraConfig = ''
      hl.define_submap("resize", function()
        local dirs = {
          right = { 1, 0 }, left = { -1, 0 },
          up = { 0, -1 }, down = { 0, 1 },
        }
        for key, d in pairs(dirs) do
          hl.bind(key, hl.dsp.window.resize({ x = d[1] * 10, y = d[2] * 10, relative = true }), { repeating = true })
          hl.bind("SHIFT + " .. key, hl.dsp.window.resize({ x = d[1] * 50, y = d[2] * 50, relative = true }), { repeating = true })
        end
        hl.bind("escape", hl.dsp.submap("reset"))
        hl.bind("Return", hl.dsp.submap("reset"))
      end)
    '';
  };
}
