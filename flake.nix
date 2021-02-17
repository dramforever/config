{
  description = "Personal configuration and packages, by dramforever";

  inputs.nixpkgs.url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/releases/nixpkgs-unstable@nixpkgs-21.05pre270157.be864bbd676/nixexprs.tar.xz";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.nix-dram = {
    url = "github:dramforever/nix-dram";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, nix-dram }:
    flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = (import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = self.overlays;
      });
    }) //
    (let
      genRev = {
        system.configurationRevision = self.rev or null;
        system.nixos.label =
          with builtins;
            if self ? lastModifiedDate && self ? revCount && self ? shortRev
            then "${substring 0 8 self.lastModifiedDate}.${toString self.revCount}.${self.shortRev}"
            else "dirty";
      };
    in {
      overlays = [
        (final: prev: import ./bits/packages.nix final prev)
        (final: prev: import ./bits/tweaks.nix final prev)
        (final: prev: import ./bits/dram.nix final prev)
        nix-dram.overlay
      ];

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

      defaultPackage."x86_64-linux" = self.legacyPackages.x86_64-linux.dramPackagesEnv;
    });
}
