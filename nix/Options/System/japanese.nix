{
  config,
  lib,
  pkgs,
  ...
}:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/Generated/env.nix;
  username = env.username;
in
{
  options.japanese.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Japanese typing and font support";
  };

  config = lib.mkIf config.japanese.enable {
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        qt6Packages.fcitx5-configtool
      ];
    };
    home-manager.users.${username}.japanese.enable = true;
  };
}
