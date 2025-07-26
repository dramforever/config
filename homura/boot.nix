{ config, lib, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.timeout = 1;

    loader.efi.canTouchEfiVariables = true;

    kernelParams = [ "quiet" "mitigations=off" ];
    supportedFilesystems = [ "nfs" ];

    initrd.systemd.enable = true;

    kernel.sysctl = {
      "vm.swappiness" = 5;
      "vm.vfs_cache_pressure" = 50;
      "kernel.sysrq" = 1;
    };

    kernelPackages = lib.mkForce pkgs.linuxPackages_asahi;
    initrd.availableKernelModules = lib.mkForce [
      # BTRFS
      "crc32c"
      "xxhash_generic"
      "blake2b_generic"
      "sha256_generic"

      # Asahi Linux
      "apple-mailbox"
      "nvme_apple"
      "pinctrl-apple-gpio"
      "macsmc"
      "macsmc-rtkit"
      "i2c-pasemi-platform"
      "tps6598x"
      "apple-dart"
      "dwc3"
      "dwc3-of-simple"
      "xhci-pci"
      "pcie-apple"
      "gpio_macsmc"
      "phy-apple-atc"
      "nvmem_apple_efuses"
      "spi-apple"
      "spi-hid-apple"
      "spi-hid-apple-of"
      "rtc-macsmc"
      # "simple-mfd-spmi"
      "spmi-apple-controller"
      "apple_nvmem_spmi" # "nvmem_spmi_mfd"
      "apple-dockchannel"
      "dockchannel-hid"
      "apple-rtkit-helper"

      # additional stuff necessary to boot off USB for the installer
      # and if the initrd (i.e. stage 1) goes wrong
      "usb-storage"
      "xhci-plat-hcd"
      "usbhid"
      "hid_generic"
    ];
  };

  systemd.tmpfiles.settings."zswap" = {
    "/sys/module/zswap/parameters/enabled"."w-".argument = "1";
    "/sys/module/zswap/parameters/zpool"."w-".argument = "zsmalloc";
  };
}
