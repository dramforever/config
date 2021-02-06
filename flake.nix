{
  description = "Personal configuration and packages, by dramforever";

  inputs.nixpkgs.url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/releases/nixos-unstable@nixos-21.03pre267812.7cbec40a095/nixexprs.tar.xz";

  inputs.nix-dram = {
    url = "github:dramforever/nix-dram";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-dram }: {
    overlays = [
      (final: prev: import ./nixos/bits/packages.nix final prev)
      (final: prev: import ./nixos/bits/tweaks.nix final prev)
      (final: prev: import ./nixos/bits/dram.nix final prev)
      nix-dram.overlay
    ];

    legacyPackages."x86_64-linux" = (import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = self.overlays;
    });

    nixosConfigurations.sakuya = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        {
          nixpkgs.overlays = self.overlays;
          system.configurationRevision = self.rev or null;
          system.nixos.label =
            with builtins;
              if self ? lastModifiedDate && self ? revCount && self ? shortRev
              then "${substring 0 8 self.lastModifiedDate}.${toString self.revCount}.${self.shortRev}"
              else "dirty";
        }
      ];
    };

    defaultPackage."x86_64-linux" = self.legacyPackages.x86_64-linux.dramPackagesEnv;
  };
}
