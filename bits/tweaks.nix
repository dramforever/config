self: super:

{
  obs-studio = super.obs-studio.override {
    ffmpeg_4 = super.ffmpeg-full.override {
      nvenc = true;
    };
  };

  bind =
    if self.system != "aarch64-linux"
    then super.bind
    else
      # https://github.com/NixOS/nixpkgs/pull/163854
      assert builtins.compareVersions super.bind.version "9.18.1" < 0;
      super.bind.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          (self.fetchpatch {
            url = "https://gitlab.isc.org/isc-projects/bind9/-/commit/b465b29eaf5ad8b8882debff1f993b8288617f22.patch";
            sha256 = "sha256-Vz861YuVbcH1hZN4ojNoZaDbWi/ZjOb/73wbeeYQHmo=";
          })
        ];
      });
}
