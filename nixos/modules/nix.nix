{ config, pkgs, lib, ... }:

{
  nix.binaryCaches = lib.mkBefore [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

  nix.gc = {
    automatic = true;
    dates = "thursday";
    options = "--delete-older-than 8d";
  };

  nix.trustedUsers = [ "root" "dram" ];

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.oraclejdk.accept_license = true;

  nix.nixPath = [ "nixpkgs=/var/lib/nixpkgs" ("nixpkgs-overlays=" + builtins.toString ../packages/list.nix) ];
}
