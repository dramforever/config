{ buildLinux, lib, fetchFromGitHub, fetchpatch
, kernelPatches
, nix-update-script
, writeShellApplication
, rustPlatform # FIXME
, ...
}@args:

(buildLinux (args // rec {
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
} // (args.argsOverride or {}))).overrideAttrs (old: {
  # Bodge for https://github.com/NixOS/nixpkgs/pulls/436245
  preConfigure = ''
    export RUST_LIB_SRC
    export KRUSTFLAGS
  '';
})
