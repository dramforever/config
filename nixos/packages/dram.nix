self: super:

{
  dramPackages = {
    nix-rebuild = super.writeScriptBin "nix-rebuild" ''
      #!${self.runtimeShell}
      nix-env -f '<nixpkgs>' -r -iA dramPackages
      kbuildsycoca5
    '';

    whois = self.lib.hiPrio self.whois;

    inherit (self)
      ark
      bat
      bind
      binutils
      chromium
      cloc
      coq_8_11
      direnv
      ffmpeg-full
      file
      git
      # goldendict
      gtkwave
      gwenview
      hexchat
      # hmcl
      j
      jq
      ksshaskpass
      libarchive
      lrzsz
      # mathematica
      mono
      obs-studio
      okular
      osu-lazer
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
      tdesktop
      tig
      tmux
      unrar
      usbutils
      vlc
      vscode
      wpsoffice
      zoom-us;
  };
}

# vim: sw=2 ts=2 cin
