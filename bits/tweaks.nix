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

  kdePackages = super.kdePackages.overrideScope (kfinal: kprev: {
    krohnkite =
      assert self.lib.versionAtLeast "0.9.9.0" kprev.krohnkite.version;
      kprev.krohnkite.overrideAttrs (old: {
        version = "0.9.9.1";
        src = self.fetchFromGitHub {
          owner = "anametologin";
          repo = "krohnkite";
          tag = "0.9.9.1";
          hash = "sha256-Famg/g+Qwux4dZa6+CMKP6dDHNHNvJDKTsWQDukHHGk=";
        };
      });
  });
}
