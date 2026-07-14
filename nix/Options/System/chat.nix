{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.chat;
  username = env.username;
in
{
  options.chat.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable chat applications";
  };

  config = lib.mkIf config.chat.enable {
    home-manager.users.${username}.chat.enable = true;
  };
}
