{
  description = "Nix configuration for my setup";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, lanzaboote }:
    let
      system = "x86_64-linux";
    in {
      nixConfig = {
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
      };
      nixosConfigurations."framework" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix

          lanzaboote.nixosModules.lanzaboote

          ({ config, pkgs, ... }: {
            environment.systemPackages = [
              pkgs.sbctl
              pkgs.cryptsetup
              pkgs.tpm2-tss
            ];

            boot.lanzaboote = {
              enable = true;

              configurationLimit = 20;
              pkiBundle = "/etc/secureboot";
            };
            security.tpm2.enable = true;
          })
        ];
      };
    };
}

