{ config, lib, pkgs, ... }:

let
  espDev = "/dev/disk/by-uuid/123B-7989";
  btrfsDev = "/dev/disk/by-uuid/84e95073-df93-45d8-a9b1-df5c43a4989c";
  swapDev = "/dev/disk/by-uuid/e1a6928f-faa8-4eca-8de0-6d2778986ae1";

  subvolume = name: {
    device = btrfsDev;
    fsType = "btrfs";
    options = [ "subvol=/${name}" "compress-force=zstd" "noatime" ];
  };

in {
  fileSystems = {
    "/" = subvolume "@root";
    "/home" = subvolume "@home";
    "/nix" = subvolume "@nix";
    "/.subvols" = subvolume "";

    "/boot" = {
      device = espDev;
      fsType = "vfat";
    };
  };

  swapDevices = [ { device = swapDev; } ];
}
