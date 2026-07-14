{ config, lib, env, pkgs, pkgs-stable, pkgs-master, inputs, ... }:

let
  actualUser = builtins.getEnv "SUDO_USER";
  user = if actualUser != "" then actualUser else builtins.getEnv "USER";
  env = import /home/${user}/.config/nixos/nix/env.nix;
  username = env.username;

  cfg = config.gaming;
in
{
  options.gaming = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Gaming";
    };
  };

  config = lib.mkIf cfg.enable {
    home.activation.applyAdwSteamGtk = ''
      echo "Applying AdwSteamGtk theme..."
      ${pkgs.adwsteamgtk}/bin/adwaita-steam-gtk --install
    '';
    home.packages = with pkgs; [
      lutris
      pkgs-master.osu-lazer-bin
      prismlauncher
      adwsteamgtk
      mindustry-wayland
      pkgs-stable.azahar
      pkgs-stable.melonDS
      pkgs-stable.ryubing
      pkgs-stable.cemu
      pkgs-stable.mgba
    ];
    xdg.desktopEntries = {
      Ryujinx = {
        name = "Ryubing";
        noDisplay = true;
        icon = "ryujinx";
        exec = "ryujinx";
        categories = [ "Game" ];
      };
      "org.azahar_emu.Azahar" = {
        name = "3DS";
        noDisplay = true;
        icon = "fceux";
        exec = "azahar";
        categories = [ "Game" ];
      };
      "io.github.Foldex.AdwSteamGtk" = {
        name = "SteamSettings";
        noDisplay = true;
        icon = "steam";
        exec = "adwaita-steam-gtk";
        categories = [ "Settings" ];
      };
      "net.kuribo64.melonDS" = {
        name = "DS";
        noDisplay = true;
        icon = "fceux";
        exec = "melonDS";
        categories = [ "Game" ];
      };

      "io.mgba.mGBA" = {
        name = "GBA";
        noDisplay = true;
        icon = "fceux";
        exec = "mgba";
        categories = [ "Game" ];
      };
      Mindustry = {
        name = "Mindustry";
        noDisplay = true;
        icon = "fceux";
        exec = "mindustry";
        categories = [ "Game" ];
      };
      "osu!" = {
        name = "Rhythm";
        icon = "osu";
        exec = "osu!";
        categories = [ "Game" ];
      };
      "info.cemu.Cemu" = {
        name = "WiiU";
        noDisplay = true;
        icon = "cemu";
        exec = "Cemu";
        categories = [ "Game" ];
      };
      "org.prismlauncher.PrismLauncher" = {
        name = "Minecraft";
        icon = "org.prismlauncher.PrismLauncher";
        exec = "prismlauncher";
        categories = [ "Game" ];
      };
      "steam" = {
        name = "Games";
        icon = "steam";
        exec = "steam";
        categories = [ "Game" ];
      };
      "net.lutris.Lutris" = {
        name = "GamesEx";
        icon = "lutris";
        exec = "lutris";
        categories = [ "Game" ];
      };
    };
  };
}
