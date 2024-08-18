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
    # clash-verge
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
    libarchive
    nix-index
    nix-output-monitor
    nodejs
    obs-studio
    # okular
    pinentry-qt
    pinta
    kdePackages.plasma-browser-integration
    polonium
    python3
    python3.pkgs.ipython
    ripgrep
    kdePackages.spectacle
    # stack
    steam
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

    linyinfeng.clash-for-windows
    linyinfeng.wemeet
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
