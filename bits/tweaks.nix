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

  m1n1 = super.m1n1.override {
    customLogo = ./nix-snowflake-asahi-colors-256.png;
  };

  nixos-option = super.nixos-option.override {
    nix = self.nix-dram;
  };

  nix-update = super.nix-update.override {
    nix = self.nix-dram;
  };

  # https://github.com/NixOS/nixpkgs/pull/493363
  # https://github.com/NixOS/nixpkgs/issues/493431
  lager = assert super.lager.patches == [] && self.lib.versionOlder super.lager.version "0.1.1";
    self.callPackage ./lager.nix {};
}
