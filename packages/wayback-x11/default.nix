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
  version = "0-unstable-2025-07-12";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wayback";
    repo = "wayback";
    rev = "5b4f53bfdbb50bf950de5c9d77c7a8f9fc9c9428";
    hash = "sha256-fhuQNcpTUlYl5eZXtvmVzwVXrJ3cOmug6F31bzCU/9E=";
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
