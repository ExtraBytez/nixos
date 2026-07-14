{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.hacking;
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
