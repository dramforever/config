self: super:

{
  nix-dram = super.make-nix-dram {
    nix = self.nixVersions.nix_2_14;
  };

  obs-studio = super.obs-studio.override {
    ffmpeg_4 = super.ffmpeg-full.override {
      withNvenc = true;
    };
  };
}
