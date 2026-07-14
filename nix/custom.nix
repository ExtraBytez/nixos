{ pkgs, lib, ... }:
{



fileSystems."/home/nate/.m/Family" = {
  device = "/dev/disk/by-uuid/1e376ffb-d686-4eba-acc2-d28e6d28f649";
  fsType = "ext4";
};
#networking.hosts = {
#"192.168.1.224" = [
 #     "music.pelmel.net" # LAN mapping
  #  ];
#};
networking.nameservers = lib.mkForce ["1.1.1.1"];
  services.caddy.enable = lib.mkForce false;
  # REQUIRED: enable graphics stack (even headless)
  hardware.graphics.enable = true;
  # AMD VAAPI drivers
  hardware.graphics.extraPackages = with pkgs; [
    mesa
  ];

  # Jellyfin runs as nate → must access /dev/dri
  users.users.nate.extraGroups = [ "video" "render" ];
 networking.firewall.enable = lib.mkForce false;
  # Force correct VAAPI driver
  environment.variables = {
    LIBVA_DRIVER_NAME = "radeonsi";
  };
networking.firewall.allowedTCPPorts = [
  3478  # TURN
  5349  # TURN-TLS (optional)
  8123
  8080
  6881
];
#  environment.etc."gai.conf".text = ''
 #   precedence ::ffff:0:0/96 100
  #'';
networking.interfaces.eno1.macAddress = lib.mkForce "02:11:22:33:44:55";
networking.firewall.allowedUDPPorts = lib.concatLists [
  [ 3478 6881 ]
  (lib.range 50000 50100)
];  

services.tailscale.enable = true;
}
