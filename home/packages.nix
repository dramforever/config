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
    (assert clash-verge-rev.version == "2.4.2"; clash-verge-rev_2_4_3)
    file
    gdb
    gh
    gtkwave
    kdePackages.gwenview
    hexchat
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
    thunderbird
    tig
    usbutils
    vlc
    wemeet
    # wolfram-engine
    # zoom-us
    xclip
    zsh-nix-fix

    xilinx-env
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
