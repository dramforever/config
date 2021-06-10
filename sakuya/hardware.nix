{ config, lib, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ pkgs.sof-firmware ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nix.maxJobs = lib.mkDefault 12;
}
