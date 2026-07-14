{
  description = "My NixOS system with Home Manager (unstable)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      master,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      actualUser = builtins.getEnv "SUDO_USER";
      user = if actualUser != "" then actualUser else builtins.getEnv "USER";
      env = import /home/${user}/.config/nixos/nix/Generated/env.nix;
      pkgs-stable = import nixpkgs-stable {
        inherit system;
      };
      pkgs-master = import master {
        inherit system;
      };
    in
    {
      nixosConfigurations.${env.hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            pkgs-stable
            pkgs-master
            ;
        };
        modules = [
          ./Main.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
