{
  description = "Nix configuration for my setup";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
    in {
      nixConfig = {
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
      };
      nixosConfigurations."framework" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixos-hardware.nixosModules.framework-11th-gen-intel
          ./framework/configuration.nix
          ./base.nix
          ./gnome.nix
       ];
      };
      nixosConfigurations."jack" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./jack/configuration.nix
          ./base.nix
          # ./kde.nix
          ./gnome.nix
        ];
      };
    };
}

