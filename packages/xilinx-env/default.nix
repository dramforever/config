# https://discourse.nixos.org/t/fhs-env-for-installing-xilinx/13150

{ stdenv, lib, buildFHSEnv }:

buildFHSEnv {
  name = "xilinx-env";
  targetPkgs = pkgs: with pkgs; [
    bash
    # xrt
    coreutils
    zlib
    stdenv.cc.cc
    ncurses5
    xorg.libXext
    xorg.libX11
    xorg.libXrender
    xorg.libXtst
    xorg.libXi
    xorg.libXft
    xorg.libxcb
    # common requirements
    freetype
    fontconfig
    glib
    gtk2
    gtk3
    libxcrypt-legacy

    # from installLibs.sh
    graphviz
    (lib.hiPrio gcc)
    unzip
    nettools
  ];
  multiPkgs = null;
}
