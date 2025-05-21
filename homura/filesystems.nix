{ config, lib, pkgs, ... }:

let
  asahiEspDev = "/dev/disk/by-uuid/4506-19FB";
  espDev = "/dev/disk/by-uuid/126A-AB17";
  btrfsDev = "/dev/disk/by-uuid/c39ea06b-8385-4be2-884a-5fcc5c44a747";

  subvolume = name: {
    device = btrfsDev;
    fsType = "btrfs";
    options = [ "subvol=/${name}" "compress-force=zstd" "noatime" ];
  };

in {
  fileSystems = {
    "/" = subvolume "@root";
    "/nix" = subvolume "@nix";
    "/.subvols" = subvolume "" // { neededForBoot = true; };

    "/boot" = {
      device = espDev;
      fsType = "vfat";
    };

    "/efi" = {
      device = asahiEspDev;
      fsType = "vfat";
    };
  };
}
