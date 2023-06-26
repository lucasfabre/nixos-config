{
  description = "secureboot and TPM configuration";

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
      modules = [
        lanzaboote.nixosModules.lanzaboote
        ({ config, pkgs, lib, ... }: {
          environment.systemPackages = [
            pkgs.sbctl
          ];

          boot.loader.systemd-boot.enable = lib.mkForce false;

          boot.lanzaboote = {
            enable = true;

            pkiBundle = "/etc/secureboot";
          };
          #security.tpm2.enable = true;
        })
      ];
    };
}

