{ config, pkgs, lib, ... }:

{
  nix = {
    gc = {
      automatic = true;
      dates = "thursday";
      options = "--delete-older-than 8d";
    };

    optimise.automatic = true;

    nixPath = [ "nixpkgs=/home/dram/code/config" ];

    package = pkgs.nix-dram;

    settings = {
      substituters = lib.mkBefore [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30" ];
      trusted-users = [ "root" "dram" ];
      keep-outputs = true;
      keep-derivations = true;
      experimental-features = [ "nix-command" "flakes" ];
      flake-registry = "";
      builders-use-substitutes = true;
      max-jobs = 12;
    };
  };

  nixpkgs.flake = {
    setNixPath = false;
    setFlakeRegistry = false;
  };
}
