{ config, pkgs, lib, ... }:

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
    jdk11
    jq
    kdePackages.kdeconnect-kde
    kdePackages.ksshaskpass
    krita
    kdePackages.krohnkite
    koneko
    libarchive
    nh
    nix-output-monitor
    (nix-update.override { nix = nix-dram; })
    nodejs
    pinentry-qt
    pinta
    kdePackages.plasma-browser-integration
    python3
    python3.pkgs.ipython
    ripgrep
    kdePackages.spectacle
    socat
    styluslabs-write-bin
    syncthingtray
    telegram-desktop
    thunderbird
    tig
    usbutils
    universal-ctags
    vlc
    wemeet
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
