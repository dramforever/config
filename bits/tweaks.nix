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

  nix-update = super.nix-update.override {
    nix = self.nix-dram;
  };
}
