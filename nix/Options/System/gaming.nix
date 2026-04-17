# nix/modules/gaming.nix
{
  config,
  lib,
  pkgs,
  winegdk,
  ...
}:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;
in
{
  options.gaming.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Gaming.";
  };

  config = lib.mkIf config.gaming.enable {
    #environment.systemPackages = with pkgs; [
    #winegdk
    #];
    programs.steam.enable = true;
    hardware.graphics.enable32Bit = true;
    hardware.graphics.enable = true;
    home-manager.users.${username}.gaming.enable = true;
  };
}
