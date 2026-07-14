{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.qemu;
  username = env.username;
in
{
  options.qemu.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "QEMU Support";
  };

  config = lib.mkIf config.qemu.enable {
    home-manager.users.${username}.qemu.enable = true;
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
      };
    };

  };
}
