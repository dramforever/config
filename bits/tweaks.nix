self: super:

{
  obs-studio = super.obs-studio.override {
    ffmpeg_4 = super.ffmpeg-full.override {
      withNvenc = true;
    };
  };
}
