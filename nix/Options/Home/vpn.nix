{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;

  cfg = config.vpn;
in
{
  options.vpn = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable ProtonVPN.";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries = {
      "proton.vpn.app.gtk" = {
        name = "Mask";
        icon = "protonvpn-gui";
        exec = "protonvpn-app";
        categories = [ "Network" ];
      };
    };
    home.packages = [
      pkgs.proton-vpn
    ];
    systemd.user.services = {
      protonvpn = {
        Unit = {
          Description = "ProtonVPN Application";
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.proton-vpn}/bin/protonvpn-app --start-minimized";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
