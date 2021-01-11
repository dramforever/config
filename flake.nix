{
  description = "Personal configuration and packages, by dramforever";

  inputs.nixpkgs.url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/releases/nixos-unstable%40nixos-21.03pre260232.733e537a8ad/nixexprs.tar.xz";

  outputs = { self, nixpkgs }: {
    overlays = [
      (final: prev: import ./nixos/packages/packages.nix final prev)
      (final: prev: import ./nixos/packages/tweaks.nix final prev)
      (final: prev: import ./nixos/packages/dram.nix final prev)
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

