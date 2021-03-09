{
  description = "Personal configuration and packages, by dramforever";

  inputs.nixpkgs.url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/releases/nixos-unstable@nixos-21.05pre273435.0aeba64fb26/nixexprs.tar.xz";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.nix-dram = {
    url = "github:dramforever/nix-dram";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, nix-dram }:
    flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = builtins.attrValues self.overlays;
      };
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
        dram = (final: prev: import ./bits/dram.nix final prev);
        nix-dram = nix-dram.overlay;
      };

      nixosConfigurations.sakuya = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./sakuya/configuration.nix
          { nixpkgs.pkgs = self.legacyPackages."x86_64-linux"; }
          genRev
        ];
      };

      nixosConfigurations.madoka = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./madoka/configuration.nix
          { nixpkgs.pkgs = self.legacyPackages."aarch64-linux"; }
          genRev
        ];
      };

      nixosConfigurations.madoka-cross = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./madoka/configuration.nix
          {
            nixpkgs = {
              pkgs = self.legacyPackagesCross."x86_64-linux"."aarch64-linux";
              # localSystem.config = "x86_64-unknown-linux-gnu";
              # crossSystem.config = "aarch64-unknown-linux-gnu";
            };
          }
          genRev
        ];
      };

      defaultPackage."x86_64-linux" = self.legacyPackages.x86_64-linux.dramPackagesEnv;

      legacyPackagesCross."x86_64-linux"."aarch64-linux" =
        import nixpkgs {
          system = "x86_64-linux";
          crossSystem.config = "aarch64-unknown-linux-gnu";
          config.allowUnfree = true;
          overlays = builtins.attrValues self.overlays;
        };
    });
}
