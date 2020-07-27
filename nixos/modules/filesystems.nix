{ config, lib, pkgs, ... }:

let
  espDev = "/dev/disk/by-uuid/36D3-0A89";
  btrfsDev = "/dev/disk/by-uuid/000f7849-ab47-4b74-8382-90842cc67d7d";
  swapDev = "/dev/disk/by-uuid/255e5755-b487-465a-8905-ac6e070300b8";

  subvolume = name: {
    device = btrfsDev;
    fsType = "btrfs";
    options = [ "subvol=/${name}" ];
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
