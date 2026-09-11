{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    ghc
    cabal-install
    kdePackages.ark
    b4
    bat
    bind
    binutils
    chromium
    clash-verge-rev
    expect
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
    lm_sensors
    nh
    nix-output-monitor
    (nix-update.override { nix = nix-dram; })
    nodejs
    picocom
    pinentry-qt
    pinta
    kdePackages.plasma-browser-integration
    python3
    python3.pkgs.ipython
    rink
    ripgrep
    kdePackages.spectacle
    socat
    sqlite-interactive
    styluslabs-write-bin
    syncthingtray
    telegram-desktop
    thunderbird
    tig
    usbutils
    universal-ctags
    vlc
    wemeet
    wl-clipboard
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
