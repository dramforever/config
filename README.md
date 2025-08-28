# config

Random config files

## Nix Flake

This repository contains a Nix Flake. To use it, use the following Flake URL:

```plain
github:dramforever/config
```

## License information

This repository is licensed under the MIT License, the same license that governs Nixpkgs. See the `LICENSE` file. However, do note the following:

### Definition of "this software"

The MIT license only applies to the code provided in this repository, and not the packages and system configurations it builds. The "software" referred to within the MIT license is the Nix language code.

If you build any package or system configuration described in this repository, it may download, run, compile, or otherwise make use of a myriad of other software governed by their respective licenses. Of particular note is that many of these software are *not* free or open source.

This Nix Flake exposes a modified Nixpkgs as its `legacyPackages.*` outputs with `config.allowUnfree` enabled. Use with caution.

### Use of `simple-nixos-mailserver`

The `kuriko` system configuration depends on [simple-nixos-mailserver], which is licensed under the GPL. Use of simple-nixos-mailserver facilities is limited to its public API, namely the `mailserver` configuration section. Furthermore, this repository does not redistribute simple-nixos-mailserver. Therefore, to the best of my knowledge, no part of this repository is a derivative work of simple-nixos-mailserver, a GPL-licensed work.

[simple-nixos-mailserver]: https://gitlab.com/simple-nixos-mailserver/nixos-mailserver
