{ config, lib, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;

  hardware.firmware = [ pkgs.pkgsCross.arm-embedded.avd-fw ];

  hardware.asahi.enable = true;

  hardware.asahi.peripheralFirmwareDirectory = pkgs.requireFile {
    name = "asahi";
    hashMode = "recursive";
    hash = "sha256-XTRIBwg87TlfaXI7eFrFD5VxJaoG1rGZ2bKDlE9aIjA=";
    message = ''
      nix-store --add-fixed sha256 --recursive <path-to-asahi-esp>/asahi
      # asahi directory containing firmware.cpio
    '';
  };
}
