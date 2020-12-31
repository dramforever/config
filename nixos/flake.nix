{
  description = "Personal configuration and packages, by dramforever";

  inputs.nixpkgs.url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/releases/nixos-unstable%40nixos-21.03pre260232.733e537a8ad/nixexprs.tar.xz";

  outputs = { self, nixpkgs }: {
    overlays = [
      (final: prev: import ./packages/packages.nix final prev)
      (final: prev: import ./packages/tweaks.nix final prev)
      (final: prev: import ./packages/dram.nix final prev)
    ];

    legacyPackages."x86_64-linux" = (import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = self.overlays;
    });

    nixosConfigurations.sakuya = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        { nixpkgs.overlays = self.overlays; }
      ];
    };

    defaultPackage."x86_64-linux" = self.legacyPackages.x86_64-linux.dramPackagesEnv;
  };
}

