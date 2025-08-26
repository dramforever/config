{ buildLinux, lib, fetchFromGitHub, fetchpatch
, kernelPatches
, nix-update-script
, writeShellApplication
, ...
}@args:

buildLinux (args // rec {
  pname = "linux-asahi";
  version = "6.16.3-1";
  modDirVersion = "${lib.head (lib.splitString "-" version)}-asahi";
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
  ] ++ args.kernelPatches;

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "linux";
    rev = "asahi-${version}";
    hash = "sha256-77DAAOfYwCdzcLxEnsxorUuwoxoVFM32x+Fg22LBG04=";
  };

  structuredExtraConfig  = with lib.kernel; {
    # For DRM_ASAHI
    DRM = yes;
    ARM64_16K_PAGES = yes;

    # For perf
    APPLE_M1_CPU_PMU = yes;

    # https://github.com/nix-community/nixos-apple-silicon/commit/93a4cc1e9cd4bbf97fe4c2a70cac35dc05d5ae8e
    # SND_DMAENGINE_PCM = module;
    SND_SOC_APPLE_MCA = module;
    SND_SOC_APPLE_MACAUDIO = module;
    SND_SOC_CS42L42_CORE = module;
    SND_SOC_CS42L42 = module;
    SND_SOC_CS42L83 = module;
    SND_SOC_CS42L84 = module;
    SND_SOC_TAS2764 = module;
    SND_SOC_TAS2770 = module;
    SND_SIMPLE_CARD_UTILS = module;
  };

  extraPassthru.updateScript = nix-update-script {
    extraArgs = [ ''--version-regex=^asahi-(${lib.escapeRegex extraMeta.branch}[.-].+)$'' ];
  };

  extraPassthru.update = writeShellApplication {
    name = "update-linux-asahi";
    text = ''
      exec ${lib.escapeShellArgs extraPassthru.updateScript} \
        --override-filename bits/linux-asahi.nix \
        linuxPackages_asahi.kernel \
        "$@"
    '';
  };
} // (args.argsOverride or {}))
