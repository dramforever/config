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

    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  hardware.cpu.intel.updateMicrocode = true;
}
