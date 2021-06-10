self: super:

{
  dramPackagesEnv = self.buildEnv {
    name = "dram-packages";
    paths = self.lib.attrValues self.dramPackages;
    pathsToLink = [ "/share" "/bin" "/etc" ];
    extraOutputsToInstall = [ "man" "doc" ];
  };

  dramPackages = {
    nix-rebuild = super.writeScriptBin "nix-rebuild" ''
      #!${self.runtimeShell}
      set -e
      out="$(nix build --json --no-link "$@" nixpkgs#dramPackagesEnv | jq -r '.[0].outputs.out')"
      nix-env --set "$out"
      kbuildsycoca5
    '';

    whois = self.lib.hiPrio self.whois;

    inherit (self) ghc cabal-install;

    inherit (self)
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
      git
      gnupg
      gtkwave
      gwenview
      hexchat
      htop
      # hmcl
      inkscape
      jdk11
      jq
      kdeconnect
      keepassxc
      kgpg
      ksshaskpass
      libarchive
      lrzsz
      # mathematica
      mono
      niv
      nix-direnv
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
      tmux
      typora
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
      zsh-completions
      zsh-autosuggestions;
  };
}

# vim: sw=2 ts=2 si
