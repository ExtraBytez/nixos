{ pkgs, ... }:
let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
in
{
  users.users.${env.username} = {
    isNormalUser = true;
    description = "${env.fullname}";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "video"
      "bluetooth"
      "libvirtd"
      "wireshark"
      "dialout"
    ];
  };
}
