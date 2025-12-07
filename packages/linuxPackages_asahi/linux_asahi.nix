{ buildLinux, lib, fetchFromGitHub, fetchpatch
, kernelPatches
, nix-update-script
, writeShellApplication
, ...
}@args:

buildLinux (args // rec {
  pname = "linux-asahi";
  version = "6.17.11-1";
  modDirVersion = lib.head (lib.splitString "-" version);
  extraMeta.branch = "6.17";

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
  ] ++ args.kernelPatches;

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "linux";
    rev = "asahi-${version}";
    hash = "sha256-bTptFNR7ehMdW3M05c0S6GZ4H19GCYvplso8zOkEnmQ=";
  };

  structuredExtraConfig  = with lib.kernel; {
    # For DRM_ASAHI
    ARM64_16K_PAGES = yes;

    # For TSO mode
    ARM64_MEMORY_MODEL_CONTROL = yes;

    # For perf
    APPLE_M1_CPU_PMU = yes;

    APPLE_PMGR_MISC = yes;
    APPLE_PMGR_PWRSTATE = yes;
  };

  extraPassthru.updateScript = nix-update-script {
    extraArgs = [ ''--version-regex=^asahi-(.+)$'' ];
  };

  extraPassthru.update = writeShellApplication {
    name = "update-linux-asahi";
    text = ''
      exec ${lib.escapeShellArgs extraPassthru.updateScript} \
        --override-filename packages/linuxPackages_asahi/linux_asahi.nix \
        linuxPackages_asahi.kernel \
        "$@"
    '';
  };
} // (args.argsOverride or {}))
