self: super:

{
  ffmpeg-full = super.ffmpeg-full.override {
    # nvenc = true;
  };

  obs-studio = super.obs-studio.override {
    # ffmpeg = self.ffmpeg-full;
  };

  linuxPackages_5_7 = super.linuxPackages_5_7.extend (lself: lsuper: {
    exfat-nofuse = lsuper.exfat-nofuse.overrideAttrs (old: {
      patches = (old.patches or []) ++ [ ./exfat-nofuse.patch ];
    });

    nvidia_x11 = lsuper.nvidia_x11.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (self.fetchpatch {
          name = "nvidia-x11-linux-5.7";
          url = "https://726688.bugs.gentoo.org/attachment.cgi?id=643102";
          sha256 = "03iwxhkajk65phc0h5j7v4gr4fjj6mhxdn04pa57am5qax8i2g9w";
        })
      ];
    });
  });
}
