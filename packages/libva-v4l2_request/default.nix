{
  stdenv,
  lib,
  meson,
  ninja,
  pkg-config,
  libva,
  libdrm,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "libva-v4l2_request";
  version = "1.2-unstable-2026-07-17";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sofus13";
    repo = "libva-v4l2_request";
    rev = "cfe6c2ab1b5346d1e973625d01b79fcb648fcf5e";
    hash = "sha256-qN/IEte/kFd2Zi9DSPTYSehCkE3MenV9a8n0LBXuICQ=";
  };

  buildInputs = [
    libva
    libdrm
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  mesonFlags = [
    (lib.mesonOption "driverdir" "${placeholder "out"}/lib/dri")
  ];
}

