{
  inputs.nixpkgs.url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/releases/nixos-unstable@nixos-21.03pre252083.2deeb58f494/nixexprs.tar.xz";

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
  };
}

