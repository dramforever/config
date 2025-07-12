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
    rev = "7bea670bd0753c2a9b3617f3a9670dda1fa55ccc";

/* FIXME: Upstream nixpkgs will use unstableGitUpdater or something
    nix hash convert --to sri --hash-algo sha256 "$(nix-prefetch-url --unpack "$(nix eval --raw .#wayback-x11.src.url)")"
*/
    hash = "sha256-IfEdN5D68+df4RMASJO6GHsF4blAmEPRHTF56FHBrz4=";
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
    homepage = "https://wayback.freedesktop.org";
    license = lib.licenses.mit;
    mainProgram = "wayback-session";
  };
}
