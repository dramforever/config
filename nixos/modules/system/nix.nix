{ config, pkgs, lib, ... }:

{
  nix = {
    binaryCaches = lib.mkBefore [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30" ];

    gc = {
      automatic = true;
      dates = "thursday";
      options = "--delete-older-than 8d";
    };

    autoOptimiseStore = true;

    trustedUsers = [ "root" "dram" ];

    nixPath = [ "nixpkgs=/home/dram/code/config" ];

    package = pkgs.nix-dram;

    extraOptions =
      let flakesEmpty = pkgs.writeText "flakes-empty.json" (builtins.toJSON { flakes = []; version = 2; });
      in ''
        keep-outputs = true
        keep-derivations = true
        experimental-features = nix-command flakes
        flake-registry = ${flakesEmpty}
      '';

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
