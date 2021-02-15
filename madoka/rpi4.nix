{ pkgs, lib, ... }:

{
  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    kernelPackages = lib.mkDefault pkgs.linuxPackages_5_10;
    kernelParams = [ "console=ttyS0,115200n8" "console=tty0" ];
  };

  # For Wi-Fi support
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
