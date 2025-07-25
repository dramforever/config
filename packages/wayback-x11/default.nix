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
  version = "0-unstable-2025-07-17";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wayback";
    repo = "wayback";
    rev = "e450c2a62f7773d532ef311fa9b209f83b13813c";

/* FIXME: Upstream nixpkgs will use unstableGitUpdater or something
    nix hash convert --to sri --hash-algo sha256 "$(nix-prefetch-url --unpack "$(nix eval --raw .#wayback-x11.src.url)")"
*/
    hash = "sha256-fIddlsPayn+lLjeEcOuEeC/TaidZvrg7QZe18zW3Fiw=";
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
