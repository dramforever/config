self: super:

{
  ffmpeg-full = super.ffmpeg-full.override {
    nvenc = true;
  };

  obs-studio = super.obs-studio.override {
    ffmpeg = self.ffmpeg-full;
  };
  
  pam-fixed =
    # If assertion fails, the fix PR was probably merged
    # https://github.com/NixOS/nixpkgs/pull/156974
    assert super.pam.patches == [];
    super.pam.overrideAttrs (_: {
      patches = [ ./patches/suid-wrapper-path.patch ];
    });

  plasma5Packages = super.plasma5Packages.overrideScope' (kself: ksuper: {
    kscreenlocker = ksuper.kscreenlocker.override {
      pam = self.pam-fixed;
    };

    plasma5 = ksuper.plasma5.overrideScope' (kpself: kpsuper: {
      kscreenlocker = ksuper.kscreenlocker.override {
        pam = self.pam-fixed;
      };
    });
  });
}
