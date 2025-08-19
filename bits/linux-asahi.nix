{ buildLinux, lib, fetchFromGitHub, fetchpatch
, kernelPatches
, ...
}@args:

buildLinux (args // {
  version = "6.16.1-asahi";
  modDirVersion = "6.16.1-asahi";
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
  ] ++ kernelPatches;

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "linux";
    rev = "asahi-6.16.1-1";
    hash = "sha256-6UEXVPTudIAQSrq6uolKGr6XqZzAFl+siOl4eluHU5s=";
  };

  structuredExtraConfig  = with lib.kernel; {
    # For DRM_ASAHI
    DRM = yes;
    ARM64_16K_PAGES = yes;

    # For perf
    APPLE_M1_CPU_PMU = yes;
  };
} // (args.argsOverride or {}))
