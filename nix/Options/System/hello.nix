{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  cfg = config.hello;
  username = env.username;
in
{
  options.hello.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Hello World";
  };

  config = lib.mkIf config.hello.enable {
    home-manager.users.${username}.hello.enable = true;
  };
}
