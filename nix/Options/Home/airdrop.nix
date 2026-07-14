{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.airdrop;
in
{
  options.airdrop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "AirDrop";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter [ "localsend_app --hidden" ];
    home.packages = [ pkgs.localsend ];
    xdg.desktopEntries = {
      "LocalSend" = {
        name = "AirDrop";
        icon = "localsend";
        exec = "localsend_app";
        categories = [ "Network" ];
      };
    };
  };
}
