self: super:

{
  ffmpeg-full = super.ffmpeg-full.override {
    nvenc = true;
  };

  obs-studio = super.obs-studio.override {
    ffmpeg = self.ffmpeg-full;
  };
}
