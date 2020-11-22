{ config, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.timeout = 0;

    loader.efi.canTouchEfiVariables = true;

    kernelParams = [ "quiet" ];

    kernelPackages = pkgs.linuxPackages_5_9;
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
