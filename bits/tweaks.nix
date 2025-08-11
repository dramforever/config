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

  libkrun = super.libkrun.override {
    virglrenderer =
      assert super.virglrenderer.version == "1.1.1";
      super.virglrenderer.overrideAttrs (old: {
        version = "1.1.1-unstable-2025-08-11";
        src = self.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "virgl";
          repo = "virglrenderer";
          rev = "423c6f3fe687093e1327ffd846cff9668c492b1d";
          hash = "sha256-NkAJ6Pk5+cAyIhK+Dx2THiuzql3JntMNNEuDRK1SWaw=";
        };

        mesonFlags = old.mesonFlags ++ [
          (self.lib.mesonOption "drm-renderers" "amdgpu-experimental,msm,asahi")
        ];
      });
  };

  nixos-option = super.nixos-option.override {
    nix = self.nix-dram;
  };
}
