{
  description = "Personal configuration and packages, by dramforever";

  inputs.nixpkgs.url = "github:tuna-nixpkgs/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nix-dram = {
    url = "github:dramforever/nix-dram";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };

  inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, simple-nixos-mailserver, nix-dram, home-manager, sops-nix }:
    flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nix-dram.overlay ] ++ builtins.attrValues self.overlays;
      };

      packages.home-manager = home-manager.defaultPackage.${system};
    }) //
    (let
      genRev = {
        system.configurationRevision = self.rev or null;
        system.nixos.label =
          with builtins;
            if self.sourceInfo ? lastModifiedDate && self.sourceInfo ? shortRev
            then "${substring 0 8 self.sourceInfo.lastModifiedDate}.${self.sourceInfo.shortRev}"
            else "dirty";
      };
    in {
      overlays = {
        packages = (final: prev: import ./bits/packages.nix final prev);
        tweaks = (final: prev: import ./bits/tweaks.nix final prev);
      };

      nixosConfigurations.sakuya = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./sakuya/configuration.nix
          { nixpkgs.pkgs = self.legacyPackages."x86_64-linux"; }
          genRev
        ];
      };

      nixosConfigurations.kuriko = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./kuriko/configuration.nix
          sops-nix.nixosModules.sops
          simple-nixos-mailserver.nixosModules.mailserver
          { nixpkgs.pkgs = self.legacyPackages."x86_64-linux"; }
          genRev
        ];
      };

      nixosConfigurations.madoka = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./madoka/configuration.nix
          sops-nix.nixosModules.sops
          { nixpkgs.pkgs = self.legacyPackages."aarch64-linux"; }
          genRev
        ];
      };

      homeConfigurations.dram = home-manager.lib.homeManagerConfiguration {
        pkgs = self.legacyPackages."x86_64-linux";
        modules = [ ./home/home.nix ];
      };
    });
}
