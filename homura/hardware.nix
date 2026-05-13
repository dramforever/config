{ config, lib, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;

  hardware.asahi.peripheralFirmwareDirectory = pkgs.requireFile {
    name = "asahi";
    hashMode = "recursive";
    hash = "sha256-7J2S4px7ozkJucmj0C45NyeZmN0HemuHlY/m4CmZjRc=";
    message = ''
      nix-store --add-fixed sha256 --recursive <path-to-asahi-esp>/asahi
    '';
  };

  hardware.firmware = [
    (pkgs.runCommand "firmware-aop-als-cal"
      {
        cal = pkgs.requireFile {
          name = "aop-als-cal.bin";
          hash = "sha256-vE7D+MueOLuweGVvKq5jt0KtrSADnqHCG6i//sTfLxg=";
          message = "aop-als-cal.bin required";
        };
      }
      ''
        install -Dm0644 "$cal" $out/lib/firmware/apple/aop-als-cal.bin
      '')
  ];
}
