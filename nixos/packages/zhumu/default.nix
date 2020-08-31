{ stdenv, lib, fetchurl
, dpkg, autoPatchelfHook
, fontconfig, glib, libpulseaudio, libxslt, mesa, nss, pulseaudio, alsaLib, libglvnd, qt5, gtk3-x11, atk, pango, cairo, libxkbcommon, libuuid
, xlibs
}:

stdenv.mkDerivation rec {
  pname = "zhumu";
  version = "2.5.361956.0302";

  src = fetchurl {
    url = "http://downloads.zhumu.me/client/latest/linux/${pname}_${version}_amd64.deb";
    sha256 = "1jblf41d5p7hv3drdsn17m8rb76l6vg696zv3m0lx45jjmkllgvx";
  };

  nativeBuildInputs = [ dpkg autoPatchelfHook ];

  buildInputs = with xlibs; [
    fontconfig glib libpulseaudio libxslt mesa nss pulseaudio alsaLib libglvnd gtk3-x11 atk pango cairo libxkbcommon libuuid
    libSM libX11 libxcb libXcomposite libXfixes libXi libXrandr libXrender libxshmfence libXtst
    xcbutilimage xcbutilkeysyms
    qt5.full qt5.qtbase qt5.qtquickcontrols2 qt5.qtmultimedia qt5.qtdeclarative qt5.qtwebengine
    stdenv.cc.cc.lib
  ];

  unpackCmd = ''
    mkdir -p source
    dpkg -x $src source
  '';
  sourceRoot = "source";

  buildPhase = ''
    cd opt/zhumu
    # Knock out vendored Qt because it apparently breaks keyboard input
    rm -rf libQt* Qt* qt* egldeviceintegrations generic iconengines imageformats platforminputcontexts platforms platformthemes audio xcbglintegrations
    cd ../..
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -r usr/* "$out/"
    rm -rf "$out/bin" # Just a broken symlink
    cp -r opt/zhumu "$out/zhumu"

    # Camera doesn't work with zhumu but *does* with ZhumuLauncher
    substituteInPlace $out/share/applications/Zhumu.desktop \
      --replace /usr/bin/zhumu "$out/zhumu/ZhumuLauncher"

    mkdir -p "$out/bin"
    ln -s "$out/zhumu/ZhumuLauncher" "$out/bin/zhumu"
  '';

  meta = {
    description = "Video Conferencing and Web Conferencing Service";
    homepage = "https://zhumu.com";
    license = lib.licenses.unfree;
  };
}
