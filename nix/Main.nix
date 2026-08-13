# Main.nix
{
  lib,
  inputs,
  pkgs-stable,
  pkgs-master,
  nur,
  winegdk,
  ...
}:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/Generated/env.nix;
  username = env.username;
  hostname = env.hostname;
in
{
  # Primary imports — including your options module
  imports = [
    (import /home/${username}/.config/nixos/nix/Generated/hardware.nix)
    (import /home/${username}/.config/nixos/nix/custom.nix)
    /home/${username}/.config/nixos/nix/Generated/options.nix # ← This enables hello.enable, etc.
    ./Options/System
    ./System
  ];

  networking.hostName = hostname;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
      "osu-lazer-bin"
      "slack"
      "obsidian"
      "mdk-sdk"
      "cloudflare-warp"
    ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  system.stateVersion = "25.11";

  # --- Home Manager ---
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit
      inputs
      pkgs-stable
      nur
      winegdk
      pkgs-master
      ;
  };
  home-manager.users.${username} =
    {
      ...
    }:
    {
      imports = [
        (import /home/${username}/.config/nixos/nix/custom-home.nix)
        ./Options/Home
        ./Home
      ];
      home.username = username;
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "25.11";
    };

  # Global Nix settings
  nix.extraOptions = ''
    warn-dirty = false
  '';
  nix.gc = {
    automatic = true;
    dates = "daily"; # or "weekly"
    options = "--delete-older-than 1d";
  };

  # Also clean old boot entries
  boot.loader.systemd-boot.configurationLimit = 1;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
    download-buffer-size = 134217728;
    cores = 0;
    max-jobs = "auto";
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
