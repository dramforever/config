self: super:

{
  dramPackages = {
    nix-rebuild = super.writeScriptBin "nix-rebuild" ''
      #!${self.runtimeShell}
      set -e
      nix-env -f '<nixpkgs>' -r -iA dramPackages "$@"
      kbuildsycoca5
    '';

    whois = self.lib.hiPrio self.whois;

    inherit (self.kdeApplications)
      kmail
      kmail-account-wizard
      kmailtransport;

    inherit (self.jetbrains)
      idea-community;

    inherit (self)
      ammonite
      anki
      ark
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
      goldendict
      gtkwave
      gwenview
      hexchat
      # hmcl
      jdk11
      jq
      kdeconnect
      kgpg
      ksshaskpass
      libarchive
      lrzsz
      # mathematica
      mono
      niv
      nodejs
      obs-studio
      okular
      # onlyoffice
      # osu-lazer
      patchelf
      pinta
      plasma-browser-integration
      python3
      quartus-prime-lite
      ripgrep
      socat
      spectacle
      sqliteInteractive
      stack
      steam
      syncthing
      syncthingtray
      tang-dynasty
      tdesktop
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
      wpsoffice
      # zhumu
      zoom-us;
  };
}

# vim: sw=2 ts=2 si
