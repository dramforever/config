{

  inputs.nixpkgs.url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-unstable/nixexprs.tar.xz";

  outputs = { self, nixpkgs }: {
    overlay = final: prev: (import ./packages/packages.nix) final prev;

    legacyPackages."x86_64-linux" = nixpkgs.legacyPackages."x86_64-linux".extend self.overlay;

    nixosConfigurations.sakuya = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ({ config, pkgs, ... }: { nixpkgs.overlays = [ self.overlay ]; })
      ];
    };
  };
}

