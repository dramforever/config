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

  fex =
    assert super.fex.version == "2509.1";
    super.fex.overrideAttrs (old: {
      patches = [
        # https://github.com/NixOS/nixpkgs/pull/450537
        (self.fetchpatch {
          name = "unittests-thunklibs-fix-build-with-llvm-21.patch";
          url = "https://github.com/FEX-Emu/FEX/commit/5af2477d005bb0ab8b11633a678ed5f6121f81b6.patch";
          hash = "sha256-QdJaexzBSOVaKc3h2uwPbX4iysqvGBDmWH938ZeXcdE=";
        })
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

  systemd-udev-wldN =
    assert self.lib.versionOlder self.systemd.version "259";
    self.systemd.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (self.fetchpatch {
          name = "udev-builtin-net_id-wldN.patch";
          url = "https://github.com/systemd/systemd/commit/01598d644f9b84f2c09467f441c8e49ac49833af.patch?full_index=1";
          hash = "sha256-mFAU9s6BqrPenBDdWWT6wKHyK/K7jk3RYydxJzj0pos=";
        })
      ];
    });
}
