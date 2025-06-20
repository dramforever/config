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
      patches = (old.patches or []) ++ [ ./kwin-tablet-cursor-hotspot.patch ];
    });
  });
}
