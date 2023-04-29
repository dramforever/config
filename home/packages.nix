{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    ghc
    cabal-install
    ark
    bat
    bind
    binutils
    bitwarden
    chromium
    file
    gdb
    gh
    gtkwave
    gwenview
    hexchat
    htop
    inkscape
    # itch
    jdk11
    jq
    kdeconnect
    # kicad
    ksshaskpass
    libarchive
    nix-index
    nix-output-monitor
    nodejs
    obs-studio
    # okular
    pinentry-qt
    pinta
    plasma-browser-integration
    plasma5Packages.bismuth
    python3
    python3.pkgs.ipython
    ripgrep
    spectacle
    # stack
    syncthingtray
    tdesktop
    thunderbird
    tig
    usbutils
    vlc
    # wolfram-engine
    write_stylus
    # zoom-us
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
