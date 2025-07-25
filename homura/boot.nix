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
  };

  systemd.tmpfiles.settings."zswap" = {
    "/sys/module/zswap/parameters/enabled"."w-".argument = "1";
    "/sys/module/zswap/parameters/zpool"."w-".argument = "zsmalloc";
  };
}
