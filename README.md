# config

Random config files

## Nix Flake

The subdirectory `nixos` contains a Nix Flake. To use it, use the following Flake URL:

```plain
github:dramforever/config?dir=nixos
```

Contents of this flake:

```console
$ nix flake show github:dramforever/config?dir=nixos
github:dramforever/config/[...]?dir=nixos
├───defaultPackage
│   └───x86_64-linux: package 'dram-packages'
├───legacyPackages
│   └───x86_64-linux: omitted (use '--legacy' to show)
├───nixosConfigurations
│   └───sakuya: NixOS configuration
└───overlays: unknown
```
