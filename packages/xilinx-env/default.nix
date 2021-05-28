# https://discourse.nixos.org/t/fhs-env-for-installing-xilinx/13150

{ stdenv, buildFHSUserEnv
, bash, coreutils, zlib, ncurses, freetype, fontconfig, glib, gtk2, gtk3, graphviz, gcc, unzip, nettools
, libXext, libX11, libXrender, libXtst, libXi, libXft, libxcb
}:

buildFHSUserEnv {
  name = "xilinx-env";
  targetPkgs = pkgs: with pkgs; [
    bash
    # xrt
    coreutils
    zlib
    stdenv.cc.cc
    ncurses
    xorg.libXext
    xorg.libX11
    xorg.libXrender
    xorg.libXtst
    xorg.libXi
    xorg.libXft
    xorg.libxcb
    xorg.libxcb
    # common requirements
    freetype
    fontconfig
    glib
    gtk2
    gtk3

    # from installLibs.sh
    graphviz
    gcc
    unzip
    nettools
  ];
  multiPkgs = null;
  profile = ''
    vitis_dir=$(echo /opt/xilinx/Vitis/*/bin)
    export PATH=$vitis_dir:$PATH
    # export XILINX_XRT="$...{xrt}"
  '';
}
