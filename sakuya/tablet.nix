{ config, pkgs, lib, ... }:

{
  services.xserver.wacom.enable = true;

  # services.udev.packages = [
  #   pkgs.huion-switcher
  #   (pkgs.make-udev-hid-bpf {
  #     name = "0010-Gaomon__M7";
  #     src = ./tablet/0010-Gaomon__M7.bpf.c;
  #   })
  # ];

  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ./tablet/hid-uclogic-dram.nix {})
  ];
}
