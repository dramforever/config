{ config, lib, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.timeout = 1;

    loader.efi.canTouchEfiVariables = false;

    kernelParams = [
      "hid_apple.fnmode=2"
      "hid_apple.swap_fn_leftctrl=1"
      "hid_apple.swap_opt_cmd=1"
      "quiet"
      "mitigations=off"
    ];

    initrd.systemd.enable = true;
    initrd.availableKernelModules = [ "apple_wdt" ];

    kernel.sysctl = {
      "vm.swappiness" = 5;
      "vm.vfs_cache_pressure" = 50;
      "kernel.sysrq" = 1;
    };

    kernelPackages = lib.mkForce pkgs.linuxPackages_asahi;
  };

  boot.loader.systemd-boot.extraFiles."asahi-efi/m1n1/boot.bin" =
    config.system.build.m1n1;

  boot.loader.grub.extraFiles."asahi-efi/m1n1/boot.bin" =
    config.system.build.m1n1;

  systemd.tmpfiles.settings."zswap" = {
    "/sys/module/zswap/parameters/enabled"."w-".argument = "1";
    "/sys/module/zswap/parameters/zpool"."w-".argument = "zsmalloc";
  };
}
