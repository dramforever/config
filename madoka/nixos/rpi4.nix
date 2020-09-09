{ pkgs, lib, ... }:

{
  boot = {
    loader = {
      grub.enable = lib.mkDefault false;
      raspberryPi = {
        enable = lib.mkDefault true;
        version = lib.mkDefault 4;
      };
    };
    kernelPackages = lib.mkDefault pkgs.linuxPackages_rpi4;
    kernelParams = [ "console=ttyS0,115200n8" "console=tty0" ];
  };

  # For Wi-Fi support
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
