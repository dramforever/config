self: super:

{
  obs-studio = super.obs-studio.override {
    ffmpeg = self.ffmpeg-full.override {
      nvenc = true;
    };
  };

  chromium = super.chromium.override {
    enableVaapi = true;
  };
}
