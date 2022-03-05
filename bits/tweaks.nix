self: super:

{
  obs-studio = super.obs-studio.override {
    ffmpeg_4 = super.ffmpeg-full.override {
      nvenc = true;
    };
  };

  # https://github.com/NixOS/nixpkgs/pull/162568 

  thermald =
    assert ! builtins.elem "--disable-werror" super.thermald.configureFlags;
    super.thermald.overrideAttrs (old: {
      configureFlags = old.configureFlags ++ [ "--disable-werror" ];
    });
}
