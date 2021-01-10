# Credit: https://github.com/GTrunSec/onlyoffice-desktopeditors-flake

{ stdenv, fetchurl, gnome3, glib, gtk3, gtk2, cairo, atk, gdk-pixbuf
, at-spi2-atk, dbus, dconf, gst_all_1, qt5, xorg, nss, nspr, alsaLib, fontconfig
, libpulseaudio, libudev0-shim, glibc, curl, pulseaudio, wrapGAppsHook
, autoPatchelfHook, makeWrapper, dpkg, lib }:
let
  noto-fonts-cjk = fetchurl {
    url = let version = "v20201206-cjk";
    in "https://github.com/googlefonts/noto-cjk/raw/${version}/NotoSansCJKsc-Regular.otf";
    sha256 = "sha256-aJXSVNJ+p6wMAislXUn4JQilLhimNSedbc9nAuPVxo4=";
  };
in stdenv.mkDerivation rec {
  pname = "onlyoffice-desktopeditors";
  version = "6.1.0";
  minor = "90";
  src = fetchurl {
    url =
      "https://github.com/ONLYOFFICE/DesktopEditors/releases/download/v${version}/onlyoffice-desktopeditors_${version}-${minor}_amd64.deb";
    sha256 = "sha256-TUaECChM3GxtB54/zNIKjRIocnAxpBVK7XsX3z7aq8o=";
  };

  buildInputs = [
    gnome3.gsettings_desktop_schemas
    glib
    gtk3
    gtk2
    cairo
    atk
    gdk-pixbuf
    at-spi2-atk
    dbus
    dconf
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtsvg
    xorg.libX11
    xorg.libxcb
    xorg.libXi
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXrandr
    xorg.libXcomposite
    xorg.libXext
    xorg.libXfixes
    xorg.libXrender
    xorg.libXtst
    xorg.libXScrnSaver
    nss
    nspr
    alsaLib
    fontconfig
    libpulseaudio
  ];

  nativeBuildInputs = [ wrapGAppsHook autoPatchelfHook makeWrapper dpkg ];

  runtimeLibs = lib.makeLibraryPath [ libudev0-shim glibc curl pulseaudio ];

  unpackPhase =
    "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";

  preConfigure = ''
    cp --no-preserve=mode,ownership ${noto-fonts-cjk} opt/onlyoffice/desktopeditors/fonts/
  '';
  installPhase = ''
    mkdir -p $out/share
    mkdir -p $out/{bin,lib}
    mv usr/bin/* $out/bin
    mv usr/share/* $out/share/
    mv opt/onlyoffice/desktopeditors $out/share
    ln -s $out/share/desktopeditors/DesktopEditors $out/bin/DesktopEditors
    substituteInPlace $out/share/applications/onlyoffice-desktopeditors.desktop \
      --replace "/usr/bin/onlyoffice-desktopeditor" "$out/bin/DesktopEditors"
      '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${runtimeLibs}" )
  '';

  enableParallelBuilding = true;
}
