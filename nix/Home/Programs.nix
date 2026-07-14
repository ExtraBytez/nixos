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
  env = import /home/${user}/.config/nixos/nix/Generated/env.nix;
in
{
  programs = {
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
          "browser.fixup.dns_first_for_single_words" = false;
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

          Default = "SearXNG";
        };
        DownloadDirectory = "/home/${env.username}";
        PromptForDownloadLocation = false;
        DefaultDownloadDirectory = "/home/${env.username}";
        DisableFormHistory = true;
        DisplayBookmarksToolbar = "Never";
      };
    };
  };
}
