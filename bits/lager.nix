{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
  catch2,
  immer,
  zug,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lager";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = "lager";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ssGBQu8ba798MSTtJeCBE3WQ7AFfvSGLhZ7WBYHEgfw=";
  };

  patches = [
    (fetchpatch {
      name = "lager-stop-using-boost-system";
      url = "https://github.com/arximboldi/lager/commit/0eb1d3d3a6057723c5b57b3e0ee3e41924ff419a.patch";
      hash = "sha256-peGpuyuCznCDqYo+9zk1FytLV+a6Um8fvjLmrm7Y2CI=";
    })
  ];

  buildInputs = [
    boost
    catch2
    immer
    zug
  ];
  nativeBuildInputs = [
    cmake
  ];
  cmakeFlags = [
    "-Dlager_BUILD_EXAMPLES=OFF"
  ];
  preConfigure = ''
    rm BUILD
  '';
  meta = {
    homepage = "https://github.com/arximboldi/lager";
    description = "C++ library for value-oriented design using the unidirectional data-flow architecture — Redux for C++";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
