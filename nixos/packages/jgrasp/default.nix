{ stdenv, stdenvNoCC, lib, fetchurl, makeWrapper, makeDesktopItem
, unzip, icoutils
, xorg, jre
}:

let
  jgraspPrebuilt =
    stdenv.mkDerivation rec {
      name = "jgrasp-prebuilt-${version}";
      version = "205_04";
      src = fetchurl {
        url = "https://www.jgrasp.org/dl4g/jgrasp/jgrasp${version}.zip";
        sha256 = "1by14yf1fc0mcbs0fgbyiqgbq948sgqa5zdp0nrmcmn70nbd8y45";
      };

      phases = [ "unpackPhase" "buildPhase" "installPhase" ];

      nativeBuildInputs = [ unzip ];
      buildInputs = [ xorg.libXt ];

      buildPhase = ''
        patchShebangs .
        cd src
        ./configure
        ./Make.sh
        cd ..
      '';

      installPhase = ''
        cp -r . $out
      '';
    };

  jgraspDesktop = makeDesktopItem rec {
    name = "jgrasp";
    exec = "jgrasp %F";
    icon = "jgrasp";
    desktopName = "jGRASP";
    comment = "IDE with Visualizations for Improving Software Comprehensibility";
    genericName = "Integrated Development Environment";
    categories = "Text;Editor;";
  };

in stdenvNoCC.mkDerivation rec {
  name = "jgrasp-${version}";

  inherit jgraspPrebuilt;

  inherit (jgraspPrebuilt) version;

  nativeBuildInputs = [ makeWrapper icoutils ];

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    makeWrapper $jgraspPrebuilt/bin/jgrasp $out/bin/jgrasp \
      --suffix PATH : "${jre}/bin"

    mkdir -p $out/share/applications
    cp ${jgraspDesktop}/share/applications/* $out/share/applications

    icotool -x $jgraspPrebuilt/data/gric.ico
    icotool -l $jgraspPrebuilt/data/gric.ico | while read iconsel
    do
      res=$(sed <<<"$iconsel" -Ee 's/.*--width=([0-9]+) --height=([0-9]+).*/\1x\2/')
      idx=$(sed <<<"$iconsel" -Ee 's/.*--index=([0-9]+).*/\1/')
      mkdir -p $out/share/icons/hicolor/$res/apps
      cp gric_$idx*.png $out/share/icons/hicolor/$res/apps/jgrasp.png
    done
  '';

  meta.license = lib.licenses.unfree;
}
