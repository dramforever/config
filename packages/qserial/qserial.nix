{ mkDerivation, fetchFromGitHub
, libusb
, qtbase, qtserialport, qtwebengine
, qmake
}: 

mkDerivation { 
  pname = "QSerial";
  version = "unstable-2020-06-23";

  src = fetchFromGitHub {
    owner = "tuna";
    repo = "QSerial";
    rev = "54cc9d9502f728dc553a09054348cf59d0a835c8";
    hash = "sha256-SCmhmHeeDTTG0xAs5qr3Vv3M2yvuGUwUdnQokMTy9Yg=";
  };


  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp QSerial "$out/bin"
    runHook postInstall
  '';

  buildInputs = [ libusb qtbase qtserialport qtwebengine ]; 
  nativeBuildInputs = [ qmake ];

  qtWrapperArgs = [ "--set QT_XCB_GL_INTEGRATION none" ];
}
