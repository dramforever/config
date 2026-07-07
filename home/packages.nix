{ config, pkgs, lib, ... }:

let
  # https://github.com/NixOS/nixpkgs/issues/538938
  thunderbird' =
    (import (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/b5aa0fbd538984f6e3d201be0005b4463d8b09f8.tar.gz";
      sha256 = "sha256-oPXCU/SSUokcGaJREHibG1CBX3+s/W7orDWQOZDsEeQ=";
    }) { localSystem = pkgs.stdenv.hostPlatform; }).thunderbird;
in

{
  home.packages = with pkgs; [
    ghc
    cabal-install
    kdePackages.ark
    bat
    bind
    binutils
    chromium
    clash-verge-rev
    file
    gdb
    gh
    gtkwave
    kdePackages.gwenview
    halloy
    htop
    inkscape
    # itch
    jdk11
    jq
    kdePackages.kdeconnect-kde
    # kicad
    kdePackages.ksshaskpass
    krita
    kdePackages.krohnkite
    koneko
    libarchive
    nh
    # nix-index
    nix-output-monitor
    (nix-update.override { nix = nix-dram; })
    nodejs
    # obs-studio
    # okular
    pinentry-qt
    pinta
    kdePackages.plasma-browser-integration
    python3
    python3.pkgs.ipython
    ripgrep
    kdePackages.spectacle
    socat
    # stack
    # steam
    styluslabs-write-bin
    syncthingtray
    telegram-desktop
    thunderbird'
    tig
    usbutils
    universal-ctags
    vlc
    wemeet
    # wolfram-engine
    # zoom-us
    xclip
    zsh-nix-fix
  ];

  home.activation.installPackages = {
    data = lib.mkForce "";
    before = lib.mkForce [];
    after = lib.mkForce [];
  };

  home.file.nix-profile = {
    source = config.home.path;
    target = ".nix-profile";
  };
}
