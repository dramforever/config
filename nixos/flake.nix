{

  inputs.nixpkgs.url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/releases/nixos-unstable@nixos-21.03pre250162.34ad166a830/nixexprs.tar.xz";

  outputs = { self, nixpkgs }: {
    overlay = final: prev: (import ./packages/packages.nix) final prev;

    legacyPackages."x86_64-linux" = (import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    }).extend self.overlay;

    nixosConfigurations.sakuya = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        { nixpkgs.overlays = [ self.overlay ]; }
      ];
    };
  };
}

