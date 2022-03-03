# https://gitlab.com/doronbehar/nix-matlab/-/blob/master/common.nix

{ stdenv, lib, buildFHSUserEnv }:

buildFHSUserEnv {
  name = "xilinx-env";
  targetPkgs = pkgs:
    (with pkgs; [
      cacert
      alsaLib # libasound2
      atk
      glib
      glibc
      cairo
      cups
      dbus
      fontconfig
      gdk-pixbuf
      #gst-plugins-base
      # gstreamer
      gtk3
      nspr
      nss
      pam
      pango
      python3
      libselinux
      libsndfile
      glibcLocales
      procps
      unzip
      zlib

      # These packages are needed since 2021b version
      gnome2.gtk
      at-spi2-atk
      at-spi2-core
      libdrm
      mesa.drivers

      gcc
      gfortran

      # nixos specific
      udev
      jre
      ncurses # Needed for CLI

      # Keyboard input may not work in simulink otherwise
      libxkbcommon
      xkeyboard_config
    ]) ++ (with pkgs.xorg; [
      libSM
      libX11
      libxcb
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXft
      libXi
      libXinerama
      libXrandr
      libXrender
      libXt
      libXtst
      libXxf86vm
    ]);

  multiPkgs = null;
}
