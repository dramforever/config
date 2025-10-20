{ config, lib, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = lib.mkMerge [
    [ "usb_storage" "sdhci_pci" ]
    { macsmc-rtkit = lib.mkForce false; }
  ];
  boot.kernelModules = [ "appledrm" "apple_dcp" "mux_apple_display_crossbar" ];
  boot.extraModulePackages = [ ];

  boot.kernelParams = [
    "hid_apple.fnmode=2"
    "hid_apple.swap_fn_leftctrl=1"
    "hid_apple.swap_opt_cmd=1"
  ];

  hardware.asahi.peripheralFirmwareDirectory = pkgs.requireFile {
    name = "asahi";
    hashMode = "recursive";
    hash = "sha256-7J2S4px7ozkJucmj0C45NyeZmN0HemuHlY/m4CmZjRc=";
    message = ''
      nix-store --add-fixed sha256 --recursive <path-to-asahi-esp>/asahi
    '';
  };
}
