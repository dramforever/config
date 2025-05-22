{ config, lib, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = [ "usb_storage" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2 swap_fn_leftctrl=1 swap_opt_cmd=1
  '';

  hardware.asahi.peripheralFirmwareDirectory = pkgs.requireFile {
    name = "asahi";
    hashMode = "recursive";
    hash = "sha256-7J2S4px7ozkJucmj0C45NyeZmN0HemuHlY/m4CmZjRc=";
    message = ''
      nix-store --add-fixed sha256 --recursive <path-to-asahi-esp>/asahi
    '';
  };
}
