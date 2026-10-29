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
  env = import /home/${user}/.config/nixos/nix/Generated/env.nix;
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
    services.upower.enable = true;
    hardware.bluetooth.enable = true;
    services.pulseaudio.enable = false;
    services.gnome.gnome-keyring.enable = true;
    services.displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        user = {
          default = "nate";
        };
        session = {
          default = "Hyprland";
        };

        cursor.size = 24;
        keyboard.layout = "us";
      };
      cursorTheme = {
        package = pkgs.catppuccin-cursors.mochaRed;
        name = "catppuccin-mocha-red-cursors";
      };
    };
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      wev
      brightnessctl
      xwayland-satellite
      gnome-keyring
      wl-clipboard
      libnotify
      adwaita-qt
      adwaita-qt6
      jetbrains-mono
      fira-code
      font-awesome
      material-design-icons
      zenity
      networkmanager-openvpn
    ];
    services.dbus.packages = with pkgs; [
      libappindicator-gtk3
    ];
    networking.firewall.allowedTCPPorts = [ 53317 ];
    networking.firewall.allowedUDPPorts = [ 53317 ];
    programs.noctalia.recommendedServices.enable = true;
    services.resolved = {
      enable = true;
      settings.Resolve = {
        DNS = [
          "9.9.9.9#dns.quad9.net"
          "149.112.112.112#dns.quad9.net"
        ];
        FallbackDNS = [ ];
        DNSOverTLS = "true";
        DNSSEC = "true";
        Domains = [ "~." ];
      };
    };
    networking.networkmanager.plugins = with pkgs; [ networkmanager-openvpn ];
    home-manager.users.${username}.windowmanager.enable = true;
  };
}
