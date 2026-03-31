{
  pkgs,
  nur,
  pkgs-stable,
  config,
  lib,
  ...
}:
let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
in
{
  home.file.".config/nvim" = {
    source = ../../data/nvim;
    recursive = true;
  };
  programs = {
    neovim = {
      enable = true;
    };
    git.enable = true;
    zsh = {
      enable = true;
      shellAliases = {
        ns = "sudo nixos-rebuild switch --flake ~/.config/nixos/nix --no-reexec --impure --quiet";
        nso = "echo 'Rebuilding NixOS...' && sudo nixos-rebuild switch --flake $HOME/.config/nixos/nix --impure --quiet --show-trace && echo Done!";
        cat = "lolcat";
        lcm = "sudo ip link set wlp0s20f3 down && sudo macchanger -r wlp0s20f3 && sudo ip link set wlp0s20f3 up";
        lcmp = "sudo ip link set wlp0s20f3 down && sudo macchanger -m 3e:30:12:6f:31:ec wlp0s20f3 && sudo ip link set wlp0s20f3 up";
        ba = "cat /sys/class/power_supply/BAT0/status && cat /sys/class/power_supply/BAT0/capacity";
        df = "duf";
        du = "dust";
        ls = "eza";
        ll = "eza -la";
        nup = "cd $HOME/.config/nixos/nix/ && sudo nix flake update";
        ngc = "sudo nix-collect-garbage -d && nix-store --optimise";
        nce = "nix-env -q | fzf --multi | xargs -r nix-env -e";
        cfg = "zeditor ~/.config/nixos/";
        gitbk = "zsh $HOME/.config/nixos/scripts/gitbk.zsh";
        dcd = "docker-compose down";
        dcu = "docker-compose up -d";
        dcuf = "docker-compose up";
        nca = "nix-env -e '.*'";
        spaper = "zsh $HOME/.config/nixos/scripts/switchwall.zsh";
        img = "chafa";
        server = "ssh ${env.username}@${env.server}";
      };
      initContent = ''
                rm -dfr ~/Downloads
                rm -dfr ~/.zsh_history
                pfetch
        	source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
                source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
                source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
                source ${pkgs.fzf}/share/fzf/key-bindings.zsh
                source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
                source $HOME/.config/nixos/data/zsh/p10k.zsh
                chpwd() {
                  clear
                  ls
                  if [[ -f shell.nix ]] && [[ -z "$IN_NIX_SHELL" ]]; then
                    nix-shell
                  fi
                }
                bindkey ' ' magic-space
                autoload -Uz edit-command-line
                zle -N edit-command-line
                bindkey '^X^E' edit-command-line
                alias -s json=lolcat
                alias -s md=lolcat
                alias -s go=nvim
                alias -s rs=nvim
                alias -s txt=lolcat
                alias -s log=lolcat
                alias -s py=nvim
                alias -s js=nvim
                alias -s ts=nvim
                alias -s html=xdg-open
                autoload -Uz zmv
                hash -d nx=~/.config/nixos/nix
                function clear-screen-and-scrollback() {
                  echoti civis >"$TTY"
                  printf '%b' '\e[H\e[2J\e[3J' >"$TTY"
                  echoti cnorm >"$TTY"
                  zle redisplay
                }
                zle -N clear-screen-and-scrollback
                bindkey '^X^L' clear-screen-and-scrollback
                function copy-buffer-to-clipboard() {
                  echo -n "$BUFFER" | wl-copy
                  zle -M "Copied to clipboard"
                }
                zle -N copy-buffer-to-clipboard
                bindkey '^X^C' copy-buffer-to-clipboard

      '';
      oh-my-zsh = {
        enable = true;
        theme = "powerlevel10k";
        custom = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
        plugins = [
          "git"
          "docker"
          "zsh-interactive-cd"
        ];
      };
    };
    fuzzel = lib.mkIf config.windowmanager.enable {
      enable = true;
      settings = {
        main = {
          icon-theme = "candy-icons";
        };
        colors = {
          background = "1e1e2edd";
          text = "cdd6f4ff";
          prompt = "bac2deff";
          placeholder = "7f849cff";
          input = "cdd6f4ff";
          match = "94e2d5ff";
          selection = "585b70ff";
          selection-text = "cdd6f4ff";
          selection-match = "94e2d5ff";
          counter = "7f849cff";
          border = "94e2d5ff";
        };
      };
    };
    alacritty = lib.mkIf config.windowmanager.enable {
      enable = true;
      settings = {
        window = {
          opacity = 0.85;
          decorations_theme_variant = "Dark";
        };
        font = {
          normal.family = "JetBrainsMono Nerd Font";
          size = 15.0; # 24.5 used to be gold but its bad on my new stuff
        };
      };
    };
    zed-editor = lib.mkIf config.windowmanager.enable {
      enable = true;
      extraPackages = [
        pkgs-stable.nixd
        pkgs-stable.ruff
        pkgs-stable.ty
        pkgs.nixfmt
        pkgs-stable.shellcheck
        pkgs-stable.shfmt
        pkgs-stable.rustfmt
      ];
      extensions = [
        "nix"
        "toml"
        "HTML"
        "catppuccin"
        "catppuccin-icons"
        "gdscript"
        "basher"
      ];
      userSettings = {
        buffer_font_family = "JetBrainsMonoNL Nerd Font Propo";
        ui_font_family = "JetBrainsMonoNL Nerd Font Propo";
        disable_ai = true;
        terminal = {
          font_family = "JetBrainsMonoNL Nerd Font Propo";
        };
        title_bar = {
          show_user_picture = true;
          show_onboarding_banner = true;
          show_project_items = true;
          show_branch_name = false;
          show_branch_icon = false;
          show_sign_in = false;
        };
        status_bar = {
          cursor_position_button = false;
          active_language_button = false;
        };
        notification_panel = {
          button = false;
        };
        collaboration_panel = {
          button = false;
        };
        outline_panel = {
          button = false;
        };
        debugger = {
          button = false;
        };
        search = {
          button = true;
        };
        terminal = {
          button = false;
        };
        diagnostics = {
          button = false;
        };
        theme = {
          mode = "dark";
          dark = "Catppuccin Mocha";
          light = "Catppuccin Mocha";
        };
        icon_theme = "Catppuccin Mocha";

        lsp = {
          nixd = {
            settings = {
              nixpkgs.expr = "import <nixpkgs> { }";
              formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
              options = {
                nixos.expr = "(builtins.getFlake (builtins.toString /home/${env.username}/.config/nixos/nix)).nixosConfigurations.${env.hostname}.options";
                home_manager.expr = "(builtins.getFlake (builtins.toString /home/${env.username}/.config/nixos/nix)).nixosConfigurations.${env.hostname}.options.home-manager.users.type.getSubOptions []";
              };
            };
          };
          bash-language-server = {
            initialization_options = {
              shellcheckPath = "${pkgs.shellcheck}/bin/shellcheck";
            };
          };
          ty = {
            initialization_options = { };
          };
          ruff = {
            initialization_options = {
              settings = {
                lineLength = 88;
                lint = {
                  extendSelect = [ "I" ];
                };
              };
            };
          };
        };
        languages = {
          Nix = {
            language_servers = [
              "nixd"
              "!nil"
            ];
          };
          "Shell Script" = {
            language_servers = [ "bash-language-server" ];
            format_on_save = "on";
            formatter = {
              external = {
                command = "${pkgs.shfmt}/bin/shfmt";
                arguments = [
                  "-i"
                  "2"
                ];
              };
            };
          };
          Python = {
            language_servers = [
              "ty"
              "ruff"
            ];
            format_on_save = "on";
            formatter = [
              { code_action = "source.fixAll.ruff"; }
              { code_action = "source.organizeImports.ruff"; }
              {
                language_server = {
                  name = "ruff";
                };
              }
            ];
          };
        };
      };
    };
    librewolf = lib.mkIf config.windowmanager.enable {
      enable = true;
      profiles.default = {
        id = 0;
        extensions = {
          force = true;
          packages =
            let
              nurPkgs = import nur { inherit pkgs; };
              tempmail = pkgs.fetchFirefoxAddon {
                name = "tempmail";
                url = "https://addons.mozilla.org/firefox/downloads/file/3990577/temp_mail-0.0.34.xpi";
                sha256 = "VM++yOpKesXpsZ/t9cwYOdJ+eAH2rLACgVgFmT21hhU=";
              };
              duolingo = pkgs.fetchFirefoxAddon {
                name = "duolingo-unlimited-hearts";
                url = "https://addons.mozilla.org/firefox/downloads/file/4625755/duolingo_unlimited_hearts-3.4.1.xpi";
                sha256 = "JaAYfGYFVl8OfWRI62f72x6e/EPKFPlhwcARSCy4pjQ=";
              };
              theme = pkgs.fetchFirefoxAddon {
                name = "theme";
                url = "https://addons.mozilla.org/firefox/downloads/file/4160061/catppuccin_indigo-1.0.xpi";
                sha256 = "zdSt2w7ROoWLjZRZdLoJMXlHnjz5t7i0uxSIwQlNq/w=";
              };
            in
            with nurPkgs.repos.rycee.firefox-addons;
            [
              theme
              violentmonkey
              darkreader
              return-youtube-dislikes
              sponsorblock
              tempmail
              proton-vpn
              bitwarden
              mal-sync
              duolingo

            ];
        };
        bookmarks = {
          force = true;
          settings = [
            {
              name = "Nate's Pages";
              toolbar = true;
              bookmarks = [
              ];
            }
          ];
        };
        settings = {
          "privacy.fingerprintingProtection.overrides" =
            "+AllTargets,-CSSPrefersColorScheme,-CSSPrefersReducedTransparency";
          "browser.display.use_document_fonts" = 0;
          "privacy.resistFingerprinting" = true;
          "browser.policies.runOncePerModification.setDefaultSearchEngine" = "StartPage";
          "browser.search.separatePrivateDefault" = false;
          "privacy.clearHistory.formdata" = true;
          "privacy.clearHistory.siteSettings" = true;
          "privacy.clearOnShutdown.downloads" = true;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown.offlineApps" = true;
          "privacy.clearOnShutdown.openWindows" = true;
          "privacy.clearOnShutdown.siteSettings" = true;
          "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = true;
          "privacy.clearOnShutdown_v2.formdata" = true;
          "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
          "privacy.clearOnShutdown_v2.siteSettings" = true;
          "privacy.clearSiteData.browsingHistoryAndDownloads" = true;
          "privacy.clearSiteData.formdata" = true;
          "privacy.clearSiteData.historyFormDataAndDownloads" = true;
          "privacy.clearSiteData.siteSettings" = true;
          "browser.search.defaultenginename" = "StartPage";
          "browser.search.order.1" = "StartPage";
          "browser.search.selectedEngine" = "StartPage";
          "browser.urlbar.placeholderName" = "StartPage";
          "browser.toolbars.bookmarks.visibility" = "always";
          "browser.warnOnQuit" = false;
          "browser.warnOnQuitShortcut" = false;
          "browser.fixup.dns_first_for_single_words" = true;
          "dom.security.https_only_mode" = false;
          "media.peerconnection.ice.default_address_only" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
      policies = {
        SearchEngines = {
          Add = [
            {
              Name = "nix";
              URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
              Alias = "nix";
              Icon = "https://search.nixos.org/favicon-96x96.png";
            }
            {
              Name = "SearXNG";
              URLTemplate = "https://search.${env.domain}/search?q={searchTerms}";
              Alias = "sear";
              Icon = "https://docs.searxng.org/_static/searxng-wordmark.svg";
            }
          ];

          Default = "StartPage";
          Remove = [
            "Google"
            "Bing"
          ];
        };
        DownloadDirectory = "/home/${env.username}";
        PromptForDownloadLocation = false;
        DefaultDownloadDirectory = "/home/${env.username}";
        DisableFormHistory = true;
      };
    };
    waybar = lib.mkIf config.windowmanager.enable {
      enable = true;
    };
  };
}
