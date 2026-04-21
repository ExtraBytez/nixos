{ lib, config, ... }:

let
  user = let u = builtins.getEnv "SUDO_USER"; in if u != "" then u else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;

  ipv4 = let
    common = {
      dns = env.dns;
      ignore-auto-dns = true;
      ignore-auto-domain = true;
    };
  in if env.address != "" then
    common // {
      method = "manual";
      address1 = "${env.address}/24";
      gateway = env.gateway;
    }
  else
    common // { method = "auto"; };

  mkProfile = base: base // {
    ipv4 = ipv4;
    ipv6.method = "ignore";
  };
in
{
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
    useDHCP = false;
    nameservers = [ env.dns ];

    networkmanager.ensureProfiles.profiles = lib.mkIf config.managenet.enable {
      main-ethernet = mkProfile {
        connection = {
          id = "main-ethernet";
          type = "ethernet";
          interface-name = env.ethinterface;
          autoconnect = true;
          autoconnect-priority = 10;
        };
      };

      main-wifi = mkProfile {
        connection = {
          id = "main-wifi";
          type = "wifi";
          autoconnect = true;
          autoconnect-priority = 20;
        };
        wifi = {
          ssid = env.ssid;
          mode = "infrastructure";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = env.netkey;
        };
      };
    };
  };
}
