{ config, pkgs, lib, ... }:

{
  nix = {
    gc = {
      automatic = true;
      dates = "thursday";
      options = "--delete-older-than 8d";
    };

    nixPath = [ "nixpkgs=/home/dram/code/config" ];

    package = pkgs.nix-dram;

    settings =
      let flakesEmpty = pkgs.writeText "flakes-empty.json" (builtins.toJSON { flakes = []; version = 2; });
      in {
        substituters = lib.mkBefore [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30" ];
        trusted-users = [ "root" "dram" ];
        keep-outputs = true;
        keep-derivations = true;
        experimental-features = [ "nix-command" "flakes" ];
        flake-registry = flakesEmpty;
        builders-use-substitutes = true;
        max-jobs = 12;
        auto-optimise-store = true;
      };

    registry = {
      nixpkgs = {
        from = { id = "nixpkgs"; type = "indirect"; };
        to = { type = "git"; url = "file:///home/dram/code/config"; };
      };

      default = {
        from = { id = "default"; type = "indirect"; };
        to = { type = "git"; url = "file:///home/dram/code/config"; };
      };
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
  };
}
