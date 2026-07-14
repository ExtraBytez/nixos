{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.editor;
  username = env.username;
in
{
  options.editor.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables ZED";
  };

  config = lib.mkIf config.editor.enable {
    home-manager.users.${username}.editor.enable = true;
  };
}
