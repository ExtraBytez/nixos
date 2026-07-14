{ pkgs, env, ... }:
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