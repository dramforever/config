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

  qt6Packages = super.qt6Packages.overrideScope (kself: ksuper: {
    fcitx5-qt =
      assert ksuper.fcitx5-qt.patches == [] && ksuper.fcitx5-qt.version == "5.1.10";
      ksuper.fcitx5-qt.overrideAttrs (old: {
        patches = [
          (self.fetchpatch2 {
            url = "https://github.com/fcitx/fcitx5-qt/commit/46a07a85d191fd77a1efc39c8ed43d0cd87788d2.patch?full_index=1";
            hash = "sha256-qv8Rj6YoFdMQLOB2R9LGgwCHKdhEji0Sg67W37jSIac=";
          })
          (self.fetchpatch2 {
            url = "https://github.com/fcitx/fcitx5-qt/commit/6ac4fdd8e90ff9c25a5219e15e83740fa38c9c71.patch?full_index=1";
            hash = "sha256-x0OdlIVmwVuq2TfBlgmfwaQszXLxwRFVf+gEU224uVA=";
          })
          (self.fetchpatch2 {
            url = "https://github.com/fcitx/fcitx5-qt/commit/1d07f7e8d6a7ae8651eda658f87ab0c9df08bef4.patch?full_index=1";
            hash = "sha256-22tKD7sbsTJcNqur9/Uf+XAvMvA7tzNQ9hUCMm+E+E0=";
          })
        ];
      });
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
