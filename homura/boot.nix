{ config, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.timeout = 0;

    loader.efi.canTouchEfiVariables = true;

    kernelParams = [ "quiet" "mitigations=off" ];
    supportedFilesystems = [ "nfs" ];

    initrd.systemd.enable = true;

    kernel.sysctl = {
      "vm.swappiness" = 5;
      "vm.vfs_cache_pressure" = 50;
      "kernel.sysrq" = 1;
    };

    kernelPatches = [
      {
        name = "hid-btf";
        patch = null;
        extraConfig = ''
          DEBUG_INFO y
          DEBUG_INFO_DWARF5 y
          DEBUG_INFO_BTF y
          DEBUG_INFO_BTF_MODULES y
          FTRACE y
          FUNCTION_TRACER y
          DYNAMIC_FTRACE y
          HID_BPF y
        '';
      }
    ];
  };

  systemd.tmpfiles.settings."zswap" = {
    "/sys/module/zswap/parameters/enabled"."w-".argument = "1";
    "/sys/module/zswap/parameters/zpool"."w-".argument = "zsmalloc";
  };
}
