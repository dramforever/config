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

  # https://gitlab.freedesktop.org/mesa/mesa/-/issues/13564
  mesa =
    assert super.mesa.version == "25.1.6";
    super.mesa.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (self.fetchpatch {
          url = "https://gitlab.freedesktop.org/mesa/mesa/-/commit/103a16e4fa36d52bb0dc6325848fbdd7b5c1372f.patch";
          hash = "sha256-WmYkCLr5zH7iBmsQpz5GZkULgr6ssjxmA3XJugs4FJk=";
        })
      ];
    });
}
