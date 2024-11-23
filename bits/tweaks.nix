self: super:

{
  obs-studio = super.obs-studio.override {
    ffmpeg = super.ffmpeg-full.override {
      withNvenc = true;
    };
  };

  nextpnr-himbaechel = super.nextpnr.overrideAttrs (old: {
    cmakeFlags = old.cmakeFlags ++ [
      "-DARCH=himbaechel"
      "-DHIMBAECHEL_GOWIN_DEVICES=all"
    ];
  });

  # https://github.com/NixOS/nixpkgs/pull/357123
  fzf =
    assert self.lib.versionOlder super.fzf.version "0.56.3";
    super.fzf.overrideAttrs (old: rec {
      version = "0.56.3";

      src = self.fetchFromGitHub {
        owner = "junegunn";
        repo = "fzf";
        rev = "v${version}";
        hash = "sha256-m/RtAjqB6YTwmzCUdKQx/e7vxqJOu1Y1N0u28i8gwEs=";
      };
    });
}
