{ config, pkgs, lib, ... }:

{
  nix = {
    binaryCaches = lib.mkBefore [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

    gc = {
      automatic = true;
      dates = "thursday";
      options = "--delete-older-than 8d";
    };

    trustedUsers = [ "root" "dram" ];

    package = pkgs.nixUnstable;

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';

    nixPath = [ "nixpkgs=/var/lib/nixpkgs" "nixpkgs-overlays=/home/dram/code/config/nixos/packages/list.nix" ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
  };
}
