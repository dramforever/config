{
  fetchFromCodeberg,
  kpackage,
  kwin,
  lib,
  qtshadertools,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "koneko";
  version = "1.0.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromCodeberg {
    owner = "snowkat";
    repo = "koneko";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JpgmZJInBXeNCW9PKq9TCnGlmJN3r1BfMqfh+5P9fyg=";
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
})
