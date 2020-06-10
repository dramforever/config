{ config, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.timeout = 0;

    loader.efi.canTouchEfiVariables = true;
    kernelParams = [ "quiet" "i915.fastboot=1" ];

    extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

    kernel.sysctl = {
      "vm.swappiness" = 5;
      "vm.vfs_cache_pressure" = 50;
    };
  };

  hardware.cpu.intel.updateMicrocode = true;
}
