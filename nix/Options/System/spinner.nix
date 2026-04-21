{
  config,
  lib,
  pkgs,
  ...
}:

let
nixosSpinnerTheme = pkgs.stdenv.mkDerivation {
  name = "plymouth-nixos-spinner";
  src = ../../../data/plymouth;
  buildInputs = [ pkgs.plymouth ];
  installPhase = ''
    mkdir -p $out/share/plymouth/themes/nixos-spinner
    cp -r * $out/share/plymouth/themes/nixos-spinner/
  '';
};
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;
in
{
  options.spinner.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Boot Spinner";
  };

  config = lib.mkIf config.spinner.enable {
    boot.plymouth = {
      enable = true;
      theme = "nixos-spinner";
      themePackages = [ nixosSpinnerTheme ];
    };
  };
}
