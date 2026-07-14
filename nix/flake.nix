{
  description = "My NixOS system with Home Manager (unstable)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    wine-gdk.url = "github:fmbearmf/winegdk-nix";
    nur.url = "github:nix-community/NUR";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      wine-gdk,
      nur,
      master,
      nix-flatpak,
      ... }@inputs:
    let
      system = "x86_64-linux";
      env = import ./env.nix;
      username = env.username;
      hostname = env.hostname;

      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-master = import master {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            pkgs-stable
            pkgs-master
            nur
            wine-gdk
            env
            ;
          winegdk = wine-gdk.packages.${system}.default;
        };
        modules = [
          ./Main.nix
          home-manager.nixosModules.home-manager
          nix-flatpak.nixosModules.nix-flatpak
        ];
      };
    };
}