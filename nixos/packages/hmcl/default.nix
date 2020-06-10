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
  name = "HMCL-${version}";
  version = "3.2.112";
  src = fetchurl {
    name = "HMCL-${version}.jar";
    url = "https://ci.huangyuhui.net/job/HMCL/112/artifact/HMCL/build/libs/HMCL-3.2.112.jar";
    sha256 = "1y8kmw2wp58wzp67rr40grbjhkk23sq3mrilv02inl0qknh397yg";
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
