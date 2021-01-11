{ config, pkgs, lib, ... }:

{
  nix = {
    binaryCaches = lib.mkBefore [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

    gc = {
      automatic = true;
      dates = "thursday";
      options = "--delete-older-than 8d";
    };

    autoOptimiseStore = true;

    trustedUsers = [ "root" "dram" ];

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';

    nixPath = [ "nixpkgs=/home/dram/code/config" ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
  };
}
