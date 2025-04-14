{ config, lib, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.timeout = 0;

    loader.efi.canTouchEfiVariables = true;

    kernelParams = [ "quiet" "mitigations=off" "mem_sleep_default=deep" ];
    supportedFilesystems = [ "nfs" ];

    initrd.systemd.enable = true;

    kernelPackages = pkgs.linuxPackages_latest;

    kernelPatches = [
      {
        patch = null;
        extraStructuredConfig = with lib.kernel; {
          X86_X32_ABI = yes;
        };
      }
    ];


    kernel.sysctl = {
      "vm.swappiness" = 5;
      "vm.vfs_cache_pressure" = 50;
      "kernel.sysrq" = 1;
    };

    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  systemd.tmpfiles.settings."zswap" = {
    "/sys/module/zswap/parameters/enabled"."w-".argument = "1";
    "/sys/module/zswap/parameters/zpool"."w-".argument = "zsmalloc";
  };

  hardware.cpu.intel.updateMicrocode = true;
}
