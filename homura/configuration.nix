{ config, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./filesystems.nix
    ./graphical.nix
    ./tablet.nix
    ./hardware.nix
    ./net.nix
    ./software.nix
    ./system.nix
    ./users.nix
    ./preservation.nix
    ./nix.nix
    ./udev.nix
    ./security.nix
    ./btrbk.nix
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "25.05"; # Did you read the comment?
}
