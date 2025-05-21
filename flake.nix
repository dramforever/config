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

  inputs.hid-bpf-uclogic = {
    url = "github:dramforever/hid-bpf-uclogic";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.NickCao = {
    url = "github:NickCao/flakes";
    flake = false;
  };

  inputs.linyinfeng = {
    url = "github:linyinfeng/nur-packages/65526f93953d1a367bc938a3c4a95a8dba41f130";
    flake = false;
  };

  inputs.nix-index-database = {
    url = "github:nix-community/nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.impermanence = {
    url = "github:nix-community/impermanence";
  };

  inputs.nixos-apple-silicon = {
    url = "github:tpwrules/nixos-apple-silicon";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.plasma-manager = {
    url = "github:nix-community/plasma-manager";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };

  outputs = { self, nixpkgs, flake-utils, simple-nixos-mailserver, nix-dram, hid-bpf-uclogic, home-manager, sops-nix, NickCao, linyinfeng, nix-index-database, impermanence, nixos-apple-silicon, plasma-manager }:
    flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nix-dram.overlay hid-bpf-uclogic.overlays.default ] ++ builtins.attrValues self.overlays;
      };

      packages.home-manager = home-manager.packages.${system}.default;

      packages.sakuya = self.nixosConfigurations.sakuya.config.system.build.toplevel;
      packages.madoka = self.nixosConfigurations.madoka.config.system.build.toplevel;
      packages.kuriko = self.nixosConfigurations.kuriko.config.system.build.toplevel;
      packages.homura = self.nixosConfigurations.homura.config.system.build.toplevel;
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
        stuff = (final: prev: {
          # rait = final.callPackage (NickCao + "/pkgs/rait") {};
          linyinfeng = final.callPackage (linyinfeng + "/pkgs") { selfLib = null; };
        });
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

      nixosConfigurations.homura = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./homura/configuration.nix
          nixos-apple-silicon.nixosModules.default
          impermanence.nixosModules.impermanence
          { nixpkgs.pkgs = self.legacyPackages."aarch64-linux"; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.dram = {
              imports = [
                ./home/home.nix
                "${plasma-manager}/modules/files.nix"
                ({ lib, ... }: {
                  options.programs.plasma.enable = lib.mkEnableOption ''
                    declarative configuration options for the KDE Plasma Desktop.
                  '';
                })
              ];
            };
          }
          genRev
        ];
      };

      homeConfigurations.dram = home-manager.lib.homeManagerConfiguration {
        pkgs = self.legacyPackages."x86_64-linux";
        modules = [
          ./home/home.nix
          nix-index-database.hmModules.nix-index
        ];
      };
    });
}
