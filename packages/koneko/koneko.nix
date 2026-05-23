{
  fetchFromCodeberg,
  kpackage,
  kwin,
  lib,
  qtshadertools,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "koneko";
  version = "0-unstable-2026-05-23";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "snowkat";
    repo = "koneko";
    rev = "a8d65c3efbc319e7d287c3d4d24c7b36e4101d21";
    hash = "sha256-C/t4WwzWxNZNfhJbpeV6dzbWIOGNQ7CiAGKgBIGIt1w=";
  };

  nativeBuildInputs = [ kpackage kwin ];
  env = {
    QSB = lib.getExe qtshadertools;
    LANG = "C.UTF-8";
  };

  dontConfigure = true;
  dontWrapQtApps = true;

  preBuild = ''
    substituteInPlace Makefile \
      --replace-fail 'QSB=' 'QSB?='
  '';

  buildPhase = ''
    runHook preBuild

    make clean-qsb
    make qsb

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    kpackagetool6 --type=KWin/Script --install=package/ --packageroot=$out/share/kwin/scripts

    runHook postInstall
  '';
}
