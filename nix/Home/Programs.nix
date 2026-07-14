{
  pkgs,
  config,
  lib,
  ...
}:
let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/Generated/env.nix;
in
{
  programs = {
    vscodium = lib.mkIf config.windowmanager.enable {
      enable = true;

      profiles.default = {
        extensions = [
          pkgs.vscode-extensions.catppuccin.catppuccin-vsc
          pkgs.vscode-extensions.catppuccin.catppuccin-vsc-icons
          pkgs.vscode-extensions.jnoortheen.nix-ide
        ];
        userSettings = {
          "workbench.colorTheme" = "Catppuccin Mocha";
          "workbench.iconTheme" = "catppuccin-mocha";
          "editor.formatOnSave" = true;
          "git.enableSmartCommit" = true;
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.serverSettings".nixd = {
            formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];

            "options" = {
              # NixOS Options
              # Replace "your-actual-hostname" with the value of env.hostname
              nixos.expr = ''(builtins.getFlake "/home/${env.username}/.config/nixos/nix").nixosConfigurations."${env.hostname}".options'';

              # Home Manager Options (Integrated via NixOS module)
              # Replace "{$env.username"" and "{$env.hostname}"
              home-manager.expr = ''(builtins.getFlake "/home/${env.username}/.config/nixos/nix").nixosConfigurations."${env.hostname}".options.home-manager.users.type.getSubOptions []'';
            };
          };
        };
      };
    };
    zsh = {
      enable = true;
      shellAliases = {
        ns = "sudo nixos-rebuild switch --flake ~/.config/nixos/nix --no-reexec --impure --quiet";
        nyaa = "nix run github:Beastwick18/nyaa";
        lcm = "sudo ip link set wlp0s20f3 down && sudo macchanger -r wlp0s20f3 && sudo ip link set wlp0s20f3 up";
        lcmp = "sudo ip link set wlp0s20f3 down && sudo macchanger -m 3e:30:12:6f:31:ec wlp0s20f3 && sudo ip link set wlp0s20f3 up";
        ba = "cat /sys/class/power_supply/BAT0/status && cat /sys/class/power_supply/BAT0/capacity";
        df = "duf";
        du = "dust";
        ls = "eza";
        ll = "eza -la";
        nup = "cd $HOME/.config/nixos/nix/ && sudo nix flake update";
        ngc = "sudo nix-collect-garbage -d && nix-store --optimise";
        cfg = "zeditor ~/.config/nixos/";
        dcd = "docker compose down";
        dcu = "docker compose up -d";
        dcuf = "docker compose up";
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
    librewolf = lib.mkIf config.windowmanager.enable {
      enable = true;
      profiles.default = {
        id = 0;
        settings = {
          "browser.display.use_document_fonts" = 0;
          "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
          "privacy.fingerprintingProtection" = true;
          "privacy.resistFingerprinting" = false;
          "browser.warnOnQuit" = false;
          "browser.warnOnQuitShortcut" = false;
          "dom.security.https_only_mode" = false;
          "media.peerconnection.ice.default_address_only" = true;
          "browser.toolbars.bookmarks.visibility" = "never";
          "privacy.clearHistory.browsingHistoryAndDownloads" = true;
          "privacy.clearHistory.cache" = true;
          "privacy.clearHistory.cookiesAndStorage" = true;
          "privacy.clearHistory.formdata" = true;
          "privacy.clearHistory.historyFormDataAndDownloads" = true;
          "privacy.clearHistory.siteSettings" = true;
          "privacy.clearOnShutdown.cache" = true;
          "privacy.clearOnShutdown.cookies" = true;
          "privacy.clearOnShutdown.downloads" = true;
          "privacy.clearOnShutdown.formdata" = true;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown.offlineApps" = true;
          "privacy.clearOnShutdown.openWindows" = true;
          "privacy.clearOnShutdown.sessions" = true;
          "privacy.clearOnShutdown.siteSettings" = true;
          "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = true;
          "privacy.clearOnShutdown_v2.cache" = true;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
          "privacy.clearOnShutdown_v2.formdata" = true;
          "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
          "privacy.clearOnShutdown_v2.siteSettings" = true;
          "privacy.clearSiteData.browsingHistoryAndDownloads" = true;
          "privacy.clearSiteData.cache" = true;
          "privacy.clearSiteData.cookiesAndStorage" = true;
          "privacy.clearSiteData.formdata" = true;
          "privacy.clearSiteData.historyFormDataAndDownloads" = true;
          "privacy.clearSiteData.siteSettings" = true;
          "privacy.clearSiteDataHeader.cache.bfcache.enabled" = true;
          "privacy.clearSiteDataHeader.cache.enabled" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown.cache" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown.cookies" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown.downloads" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown.formdata" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown.history" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown.offlineApps" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown.sessions" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown.siteSettings" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown_v2.cache" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown_v2.downloads" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown_v2.formdata" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
          "services.sync.prefs.sync.privacy.clearOnShutdown_v2.siteSettings" = true;
          "extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";
          "layout.css.prefers-color-scheme.content-override" = 0;
          "privacy.userContext.newTabContainerOnLeftClick.enabled" = true;
        };
      };
      policies = {
        "Containers" = {
          "Default" = [
            {
              "name" = "1";
              "icon" = "fingerprint";
              "color" = "blue";
            }
            {
              "name" = "2";
              "icon" = "fingerprint";
              "color" = "turquoise";
            }
            {
              "name" = "3";
              "icon" = "fingerprint";
              "color" = "green";
            }
            {
              "name" = "4";
              "icon" = "fingerprint";
              "color" = "yellow";
            }
            {
              "name" = "5";
              "icon" = "fingerprint";
              "color" = "orange";
            }
            {
              "name" = "6";
              "icon" = "fingerprint";
              "color" = "red";
            }
            {
              "name" = "7";
              "icon" = "fingerprint";
              "color" = "pink";
            }
            {
              "name" = "8";
              "icon" = "fingerprint";
              "color" = "purple";
            }
            {
              "name" = "9";
              "icon" = "fingerprint";
              "color" = "toolbar";
            }
          ];
        };
        "Extensions" = {
          "Install" = [
            "https://addons.mozilla.org/firefox/downloads/file/4875950/bitwarden_password_manager-2026.6.1.xpi"
            "https://addons.mozilla.org/firefox/downloads/file/4851750/proton_vpn_firefox_extension-1.3.5.xpi"
            "https://addons.mozilla.org/firefox/downloads/file/4897574/sponsorblock-6.1.7.xpi"
            "https://addons.mozilla.org/firefox/downloads/file/4773733/user_agent_string_switcher-0.6.7.xpi"
          ];
        };
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

          Default = "SearXNG";
        };
        DownloadDirectory = "/home/${env.username}";
        PromptForDownloadLocation = false;
        DefaultDownloadDirectory = "/home/${env.username}";
      };
    };
  };
}
