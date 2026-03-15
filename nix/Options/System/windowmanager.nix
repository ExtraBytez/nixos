{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;
in
{
  options.windowmanager.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the Hyprland Window Manager";
  };

  config = lib.mkIf config.windowmanager.enable {
    programs.hyprland.enable = true;
    environment.systemPackages = with pkgs; [
      inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
      wev
      brightnessctl
      xwayland-satellite
      fuzzel
      gnome-keyring
      wl-clipboard
      (catppuccin-sddm.override {
        flavor = "mocha";
        accent = "red";
        font = "Noto Sans";
        fontSize = "9";
        loginBackground = false;
      })
      mako
      libnotify
      adwaita-qt
      adwaita-qt6
      jetbrains-mono
      fira-code
      font-awesome
      material-design-icons
      polkit_gnome
      zenity
    ];
    services.dbus.packages = with pkgs; [
      libappindicator-gtk3
    ];
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
    services.dbus.enable = true;
    home-manager.users.${username}.windowmanager.enable = true;
  };
}
