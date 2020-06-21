{ config, lib, pkgs, ... }:

let
  espDev = "/dev/disk/by-uuid/C683-59B7";
  btrfsDev = "/dev/disk/by-uuid/167cb629-cf53-4c0d-897a-ee4b3628a986";
  swapDev = "/dev/disk/by-uuid/6935c2f6-8ed2-4025-91a1-a9411c1e9021";

  subvolume = name: {
    device = btrfsDev;
    fsType = "btrfs";
    options = [ "subvol=/${name}" ];
  };

in {
  fileSystems = {
    "/" = subvolume "@nixos-root";
    "/home" = subvolume "@home";
    "/nix" = subvolume "@nix";

    "/boot" = {
      device = espDev;
      fsType = "vfat";
    };
  };

  swapDevices = [ { device = swapDev; } ];
}
