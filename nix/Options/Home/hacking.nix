{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;

  cfg = config.hacking;
in
{
  options.hacking = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hacking.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.activation.ensureCutterConfig = ''
      mkdir -p ~/.config/rizin
          cp -f ${../../../data/cutter/cutter.ini} ~/.config/rizin/cutter.ini
          chmod u+w ~/.config/rizin/cutter.ini
    '';
    home.packages = [
      pkgs.tor-browser
      (pkgs.cutter.withPlugins (
        ps: with ps; [
          jsdec
          rz-ghidra
        ]
      ))
    ];
    xdg.desktopEntries = {
      "torbrowser" = {
        name = "DarkWeb";
        icon = "torbrowser";
        exec = "tor-browser";
        categories = [ "Network" ];
      };
    "org.wireshark.Wireshark" = {
      name = "Network";
      icon = "wireshark";
      exec = "wireshark";
      categories = [ "Network" ];
    };
    "re.rizin.cutter" = {
      name = "Decompile";
      icon = "cutter";
      exec = "cutter";
      categories = [ "Development" ];
    };
  };
  };
}
