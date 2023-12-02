{
  description = "Nix configuration for my setup";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }:
    let
      system = "x86_64-linux";
    in {
      nixConfig = {
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
      };
      nixosConfigurations."framework" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./framework/configuration.nix
       ];
      };
      nixosConfigurations."jack" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./jack/configuration.nix
        ];
      };
    };
}

