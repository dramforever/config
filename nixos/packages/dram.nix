self: super:

{
  dramPackages = {
    whois = self.lib.hiPrio self.whois;

    inherit (self)
      ark
      bat
      bind
      binutils
      chromium
      cloc
      direnv
      ffmpeg-full
      file
      git
      gwenview
      hexchat
      # hmcl
      jq
      libarchive
      lrzsz
      # mathematica
      obs-studio
      okular
      patchelf
      pinta
      plasma-browser-integration
      socat
      spectacle
      sqliteInteractive
      tdesktop
      tmux
      vlc
      vscode;
  };
}
