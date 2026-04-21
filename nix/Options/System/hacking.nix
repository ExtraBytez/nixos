{
  config,
  lib,
  pkgs,
  ...
}:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;
in
{
  options.hacking.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Hacking.";
  };

  config = lib.mkIf config.hacking.enable {
    environment.systemPackages = with pkgs; [
      binutils
      radare2
      exiftool
      httpie
      ltrace
      cyme
      nmap
      util-linux
      wireshark
      hollywood
    ];
    #programs.firejail.enable = true;
    programs.wireshark = {
      enable = true;
      dumpcap.enable = true;
      usbmon.enable = true;
    };
    home-manager.users.${username}.hacking.enable = true;
  };
}
