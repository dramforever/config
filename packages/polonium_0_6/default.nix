# https://github.com/NixOS/nixpkgs/pull/272445
# 1.0b1 just does not work with plasma 5 and is not really usable rn

{ libsForQt5 }:

libsForQt5.callPackage ./polonium.nix {}
