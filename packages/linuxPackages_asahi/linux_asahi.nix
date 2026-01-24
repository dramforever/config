{ buildLinux, lib, fetchFromGitHub, fetchpatch
, kernelPatches
, nix-update-script
, writeShellApplication
, ...
}@args:

buildLinux (args // rec {
  pname = "linux-asahi";
  version = "6.18.6-1";
  modDirVersion = lib.head (lib.splitString "-" version);
  extraMeta.branch = "6.17";

  inherit kernelPatches;

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "linux";
    rev = "asahi-${version}";
    hash = "sha256-+SNtDEDxQqhLr0GPV1RQ51FqqGXrI+0Aeyv8XQFHgsg=";
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
