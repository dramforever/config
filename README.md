# config

Random config files with some test

## Nix Flake

This repository contains a Nix Flake. To use it, use the following Flake URL:

```plain
github:dramforever/config
```

Contents of this flake:

```console
$ nix flake show github:dramforever/config
github:dramforever/config/[...]
├───defaultPackage
│   └───x86_64-linux: package 'dram-packages'
├───legacyPackages
│   ├───aarch64-linux: omitted (use '--legacy' to show)
│   ├───i686-linux: omitted (use '--legacy' to show)
│   ├───x86_64-darwin: omitted (use '--legacy' to show)
│   └───x86_64-linux: omitted (use '--legacy' to show)
├───nixosConfigurations
│   ├───madoka: NixOS configuration
│   └───sakuya: NixOS configuration
└───overlays: unknown
```
