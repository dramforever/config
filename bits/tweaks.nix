self: super:

{
  ffmpeg-full = super.ffmpeg-full.override {
    nvenc = true;
  };

  obs-studio = super.obs-studio.override {
    ffmpeg = self.ffmpeg-full;
  };

  # linuxPackages_5_7 = super.linuxPackages_5_7.extend (lself: lsuper: {
  #   exfat-nofuse = lsuper.exfat-nofuse.overrideAttrs (old: {
  #     patches = (old.patches or []) ++ [ ./patches/exfat-nofuse.patch ];
  #   });
  #
  #   nvidia_x11 = lsuper.nvidia_x11.overrideAttrs (old: {
  #     patches = (old.patches or []) ++ [
  #       (self.fetchpatch {
  #         name = "nvidia-x11-linux-5.7";
  #         url = "https://726688.bugs.gentoo.org/attachment.cgi?id=643102";
  #         sha256 = "03iwxhkajk65phc0h5j7v4gr4fjj6mhxdn04pa57am5qax8i2g9w";
  #       })
  #     ];
  #   });
  # });

  sage = super.sage.overrideAttrs (old: {
    buildInputs =
      with builtins;
      let notTest = x: (parseDrvName x.name).name != "sage-tests";
      in filter notTest old.buildInputs;
  });

  dfu-util = super.dfu-util.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      (self.fetchpatch {
        url = "https://github.com/z4yx/dfu-util/commit/59e024c5d0e6edb84bd90594371dca63efa18212.diff";
        sha256 = "sha256-8J92J2c0fpiJHp7xr0s/TBMxOgJu1V+JHh3fyXkIJXU=";
      })
    ];
  });

  makeWrapper =
    self.makeSetupHook
      { deps = [ self.dieHook ]; substitutions = { shell = self.buildPackages.runtimeShell; }; }
      (self.path + "/pkgs/build-support/setup-hooks/make-wrapper.sh");

  nixUnstable =
    if self.buildPlatform != self.hostPlatform
    then super.nixUnstable.overrideAttrs (old: {
        makeFlags = (old.makeFlags or []) ++ [ "man-pages=" ];
    });
    else super.nixUnstable;

  radvd = super.radvd.overrideAttrs (old: {
    makeFlags = (old.makeFlags or []) ++ [ "AR=$AR" ];
  });
}
