{ config, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.timeout = 0;

    loader.efi.canTouchEfiVariables = true;

    kernelParams = [ "quiet" "mitigations=off" "mem_sleep_default=deep" ];
    supportedFilesystems = [ "nfs" ];

    initrd.systemd.enable = true;

    kernelPackages = pkgs.linuxPackages_latest;

    kernel.sysctl = {
      "vm.swappiness" = 5;
      "vm.vfs_cache_pressure" = 50;
      "kernel.sysrq" = 1;
    };
  };

  boot.blacklistedKernelModules = [ "esp4" "esp6" "rxrpc" ];
  boot.extraModprobeConfig = ''
    install esp4 /run/current-system/sw/bin/false
    install esp6 /run/current-system/sw/bin/false
    install rxrpc /run/current-system/sw/bin/false
  '';

  systemd.tmpfiles.settings."zswap" = {
    "/sys/module/zswap/parameters/enabled"."w-".argument = "1";
    "/sys/module/zswap/parameters/zpool"."w-".argument = "zsmalloc";
  };

  hardware.cpu.intel.updateMicrocode = true;
}
