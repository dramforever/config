_: (import ./flake-compat.nix { src = ./.; }).defaultNix.legacyPackages.${builtins.currentSystem}
