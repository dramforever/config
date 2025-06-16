self: super:

{
  obs-studio = super.obs-studio.override {
    ffmpeg = super.ffmpeg-full.override {
      withNvenc = true;
    };
  };

  nextpnr-himbaechel = super.nextpnr.overrideAttrs (old: {
    cmakeFlags = old.cmakeFlags ++ [
      "-DARCH=himbaechel"
      "-DHIMBAECHEL_GOWIN_DEVICES=all"
    ];
  });

  kdePackages = super.kdePackages.overrideScope (kself: ksuper: {
    kwin = ksuper.kwin.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (self.fetchpatch {
          url = "https://invent.kde.org/plasma/kwin/-/merge_requests/7787.patch";
          hash = "sha256-2NSRZiuEmuOHtS0McKkKL7cTEJRd8nphTW2hkTu1ugw=";
        })
      ];
    });
  });

  linuxPackages_asahi = self.linuxPackagesFor (self.callPackage ./linux-asahi.nix {
    kernelPatches = with self.kernelPatches; [
      bridge_stp_helper
      request_key_helper
    ];
  });

  dt-schema = assert self.lib.versionOlder super.dt-schema.version "2025.06";
    super.dt-schema.overrideAttrs (old: {
      version = "2025.06.1";
      src = self.fetchFromGitHub {
        owner = "devicetree-org";
        repo = "dt-schema";
        tag = "v2025.06.1";
        hash = "sha256-OWpMBXwEX7QHA7ahM6m1NN/aY17lA0pANPaekJjRv1c=";
      };
    });
}
