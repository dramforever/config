{ config, pkgs, ... }:

{
  imports = [
    ./modules/hardware-configuration.nix

    ./modules/boot.nix
    ./modules/graphical.nix
    ./modules/net.nix
    ./modules/nix.nix
    ./modules/services.nix
    ./modules/software.nix
    ./modules/system.nix
    ./modules/users.nix
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
