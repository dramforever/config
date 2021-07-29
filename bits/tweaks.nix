self: super:

{
  ffmpeg-full = super.ffmpeg-full.override {
    nvenc = true;
  };

  obs-studio = super.obs-studio.override {
    ffmpeg = self.ffmpeg-full;
  };

  nix-dram = super.nix-dram.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      (self.fetchpatch {
        name = "fix-follows.diff";
        url = "https://github.com/CitadelCore/nix/commit/cfef23c040c950222b3128b9da464d9fe6810d79.diff";
        sha256 = "sha256-KpYSX/k7FQQWD4u4bUPFOUlPV4FyfuDy4OhgDm+bkx0=";
      })
    ];
  });
}
