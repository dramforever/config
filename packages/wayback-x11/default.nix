{
  fetchFromGitLab,
  lib,
  libxkbcommon,
  meson,
  ninja,
  pixman,
  pkg-config,
  scdoc,
  stdenv,
  unstableGitUpdater,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots,
  xwayland,
}:

stdenv.mkDerivation {
  pname = "wayback";
  version = "0-unstable-2025-07-11";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wayback";
    repo = "wayback";
    rev = "8bc189f533bf2c62656ebb482441eed9464160db";
    hash = "sha256-jyifQ6yXf1g6S9SFfJfvswEJwX8+kTqhj6H2j4I1Gkk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    libxkbcommon
    pixman
    wayland
    wayland-protocols
    wayland-scanner
    wlroots
    xwayland
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "X11 compatibility layer leveraging wlroots and Xwayland";
    homepage = "https://gitlab.freedesktop.org/wayback/wayback";
    license = lib.licenses.mit;
    mainProgram = "wayback-session";
  };
}
