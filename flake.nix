{
  description = "Nix configuration for my setup";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # modules
    secureboottpm.url = "./secureboottpm";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, secureboottpm }:
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
       ] ++ secureboottpm.modules;
      };
    };
}

