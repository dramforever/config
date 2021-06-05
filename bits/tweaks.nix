self: super:

{
  ffmpeg-full = super.ffmpeg-full.override {
    nvenc = true;
  };

  obs-studio = super.obs-studio.override {
    ffmpeg = self.ffmpeg-full;
  };

  # linuxPackages_5_7 = super.linuxPackages_5_7.extend (lself: lsuper: {
  #   exfat-nofuse = lsuper.exfat-nofuse.overrideAttrs (old: {
  #     patches = (old.patches or []) ++ [ ./patches/exfat-nofuse.patch ];
  #   });
  #
  #   nvidia_x11 = lsuper.nvidia_x11.overrideAttrs (old: {
  #     patches = (old.patches or []) ++ [
  #       (self.fetchpatch {
  #         name = "nvidia-x11-linux-5.7";
  #         url = "https://726688.bugs.gentoo.org/attachment.cgi?id=643102";
  #         sha256 = "03iwxhkajk65phc0h5j7v4gr4fjj6mhxdn04pa57am5qax8i2g9w";
  #       })
  #     ];
  #   });
  # });

  sage = super.sage.overrideAttrs (old: {
    buildInputs =
      with builtins;
      let notTest = x: (parseDrvName x.name).name != "sage-tests";
      in filter notTest old.buildInputs;
  });

  dfu-util = super.dfu-util.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      (self.fetchpatch {
        url = "https://github.com/z4yx/dfu-util/commit/59e024c5d0e6edb84bd90594371dca63efa18212.diff";
        sha256 = "sha256-8J92J2c0fpiJHp7xr0s/TBMxOgJu1V+JHh3fyXkIJXU=";
      })
    ];
  });

  makeWrapper =
    self.makeSetupHook
      { deps = [ self.dieHook ]; substitutions = { shell = self.buildPackages.runtimeShell; }; }
      (self.path + "/pkgs/build-support/setup-hooks/make-wrapper.sh");

  radvd = super.radvd.overrideAttrs (old: {
    preBuild = ''
      ${old.preBuild or ""}
      makeFlags+=("AR=$AR")
    '';
  });

  nixUnstable =
    if self.buildPlatform != self.hostPlatform
    then
      super.nixUnstable.overrideAttrs (old: {
        configureFlags = (old.configureFlags or []) ++ [ "--disable-doc-gen" ];
        outputs = self.lib.remove "man" (self.lib.remove "doc" old.outputs);
      })
    else super.nixUnstable;

  nix-dram = super.nix-dram.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      (self.fetchpatch {
        name = "fix-follows.diff";
        url = "https://github.com/CitadelCore/nix/commit/cfef23c040c950222b3128b9da464d9fe6810d79.diff";
        sha256 = "sha256-KpYSX/k7FQQWD4u4bUPFOUlPV4FyfuDy4OhgDm+bkx0=";
      })
    ];
  });

  discord =
    if self.lib.versionOlder super.discord.version "0.0.14"
    then super.discord.overrideAttrs (old: rec {
      version = "0.0.14";
      src = self.fetchurl {
        url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        sha256 = "1rq490fdl5pinhxk8lkfcfmfq7apj79jzf3m14yql1rc9gpilrf2";
      };
    })
    else super.discord;
 }
