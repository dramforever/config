{ config, lib, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = [ "usb_storage" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  hardware.asahi.peripheralFirmwareDirectory = pkgs.requireFile {
    name = "asahi";
    hashMode = "recursive";
    hash = "sha256-7J2S4px7ozkJucmj0C45NyeZmN0HemuHlY/m4CmZjRc=";
    message = ''
      nix-store --add-fixed sha256 --recursive <path-to-asahi-esp>/asahi
    '';
  };
}
