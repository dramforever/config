{ config, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.timeout = 0;

    loader.efi.canTouchEfiVariables = true;

    kernelParams = [ "quiet" "mitigations=off" "intel_pstate=passive" "mem_sleep_default=deep" ];

    kernelPackages = pkgs.linuxPackages_zen;
    # extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

    supportedFilesystems = [ "ntfs" "exfat" ];

    kernel.sysctl = {
      "vm.swappiness" = 5;
      "vm.vfs_cache_pressure" = 50;
      "kernel.sysrq" = 1;
    };
  };

  hardware.cpu.intel.updateMicrocode = true;
}
