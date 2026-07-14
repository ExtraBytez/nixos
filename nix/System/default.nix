{ pkgs, lib, ... }:
let
  dir = ./.;
in
{
  imports = builtins.map (file: dir + "/${file}") (builtins.filter (file: builtins.match ".*\\.nix" file != null && file != "default.nix") (builtins.attrNames (builtins.readDir dir)));
}