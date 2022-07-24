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
    nodejs
    obs-studio
    okular
    pinentry-qt
    pinta
    plasma-browser-integration
    plasma5Packages.bismuth
    python3
    ripgrep
    spectacle
    stack
    syncthingtray
    tdesktop
    thunderbird
    tig
    usbutils
    vlc
    vscode
    wolfram-engine
    write_stylus
    zoom-us

    xilinx-env
    matlab-env
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
