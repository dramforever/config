{ stdenvNoCC, lib, fetchurl, makeWrapper
, gcc-unwrapped, flite, alsaLib, xorg, wayland, libglvnd
, oraclejre }:

let
  libPath =
    lib.makeLibraryPath
      [ gcc-unwrapped flite alsaLib
        xorg.libX11 xorg.libXcursor xorg.libXrandr xorg.libXxf86vm
        wayland libglvnd ];

in stdenvNoCC.mkDerivation rec {
  name = "hmcl";
  version = "3.3.172";
  src = fetchurl {
    name = "HMCL-${version}.jar";
    url = "http://ci.huangyuhui.net/job/HMCL/172/artifact/HMCL/build/libs/HMCL-${version}.jar";
    hash = "sha256-DuiP3KPQVywK+rozyKxRrKqiR5J7Kl3Xp2UcWdQMRvM=";
  };
  phases = [ "installPhase" ];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin $out/share
    cp $src $out/share/HMCL.jar
    makeWrapper ${oraclejre}/bin/java $out/bin/hmcl \
      --add-flags "-jar $out/share/HMCL.jar" \
      --suffix LD_LIBRARY_PATH : ${libPath}
  '';
}
