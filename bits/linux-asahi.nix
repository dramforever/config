{ buildLinux, lib, fetchFromGitHub, fetchpatch
, kernelPatches
, ...
}@args:

buildLinux (args // {
  version = "6.16-asahi";
  modDirVersion = "6.16.0-asahi";
  extraMeta.branch = "6.16";

  kernelPatches = [
    {
      name = "revert-disconnected_hpd_event";
      patch = fetchpatch {
        name = "revert-disconnected_hpd_event.patch";
        url = "https://github.com/AsahiLinux/linux/commit/794a1166e09f0b836b95c13fc7f999c5a08a6260.patch";
        revert = true;
        hash = "sha256-107ZKR5moEC0riw9L9SsANenZTnc6a9Aoha/kEHMHws=";
      };
    }
    {
      name = "btrfs-tree-log";
      patch = fetchpatch {
        name = "btrfs-tree-log.patch";
        url = "https://github.com/torvalds/linux/commit/0a32e4f0025a74c70dcab4478e9b29c22f5ecf2f.patch";
        hash = "sha256-u9QY8cwTcJoPxpIJLeDnapDJ/7M7cnxZT4HjrhSQIkg=";
      };
    }
  ] ++ kernelPatches;

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "linux";
    rev = "asahi-6.16-2";
    hash = "sha256-IpIXlGadBBNAEbEcnygYFQvEzSJazkUYVO/wv56m47w=";
  };

 structuredExtraConfig  = with lib.kernel; {
    DRM = yes; # Required for DRM_ASAHI
    ARM64_16K_PAGES = yes; # Required for DRM_ASAHI

    HID_APPLE = module;

    # The rest just look important okay
    APPLE_M1_CPU_PMU = yes;
    BT_LE = yes;
    CGROUP_MISC = yes;
    CPU_IDLE_GOV_TEO = yes;
    GPIO_SYSFS = yes;
    NVME_VERBOSE_ERRORS = yes;
  };
} // (args.argsOverride or {}))
