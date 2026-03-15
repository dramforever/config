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

  # https://github.com/NixOS/nixpkgs/pull/499871
  qemu-user =
    assert ! builtins.elem "--disable-gnutls" super.qemu-user.configureFlags;
    (super.qemu-user.override {
      gnutls = null;
    }).overrideAttrs (old: {
      configureFlags = old.configureFlags ++ [ "--disable-gnutls" ];
    });
}
