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
        version = "0.9.9.0-unstable-2025-04-28";
        src = self.fetchFromGitHub {
          owner = "anametologin";
          repo = "krohnkite";
          rev = "879810aa30baee8490e488cbfd0737957c69f745";
          hash = "sha256-Famg/g+Qwux4dZa6+CMKP6dDHNHNvJDKTsWQDukHHGk=";
        };
      });
  });
}
