{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ghc
    cabal-install
    ark
    audacity
    bat
    bind
    binutils
    chromium
    cloc
    coq_8_11
    direnv
    dotnet-sdk
    ffmpeg-full
    file
    gdb
    # git
    gtkwave
    gwenview
    hexchat
    htop
    # hmcl
    inkscape
    jdk11
    jetbrains.idea-community
    jq
    kdeconnect
    keepassxc
    kgpg
    ksshaskpass
    libarchive
    lrzsz
    # mathematica
    mono
    # niv
    # nix-direnv
    nix-index
    nodejs
    obs-studio
    okular
    # onlyoffice
    # osu-lazer
    patchelf
    pinentry-qt
    pinta
    plasma-browser-integration
    plasma5Packages.bismuth
    python3
    # quartus-prime-lite
    ripgrep
    socat
    spectacle
    sqliteInteractive
    stack
    steam
    syncthing
    syncthingtray
    # tang-dynasty
    tdesktop
    thunderbird
    tig
    # tmux
    # typora
    universal-ctags
    unrar
    usbutils
    verilog
    vlc
    vscode
    wireshark
    wolfram-engine
    # zhumu
    zoom-us
    # zsh-completions
    # zsh-autosuggestions
  ];
}
