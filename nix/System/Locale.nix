{ ... }:
let
actualUser = builtins.getEnv "SUDO_USER";
user = if actualUser != "" then actualUser else builtins.getEnv "USER";
env = import /home/${user}/.config/nixos/nix/env.nix;
in
{
  time.timeZone = "${env.timezone}";
  i18n = {
    defaultLocale = "${env.locale}";
    extraLocaleSettings = {
      LC_ADDRESS = "${env.locale}";
      LC_IDENTIFICATION = "${env.locale}";
      LC_MEASUREMENT = "${env.locale}";
      LC_MONETARY = "${env.locale}";
      LC_NAME = "${env.locale}";
      LC_NUMERIC = "${env.locale}";
      LC_PAPER = "${env.locale}";
      LC_TELEPHONE = "${env.locale}";
      LC_TIME = "${env.locale}";
    };
  };
}
