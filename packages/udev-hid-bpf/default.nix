{ lib, stdenv, fetchFromGitLab, rustPlatform
, buildPackages
, elfutils, udev, libbpf, zlib
, pkg-config, cargo, rustc, meson, ninja, bpftools
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "udev-hid-bpf";
  version = "2.1.0-unstable-20250108";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libevdev";
    repo = finalAttrs.pname;
    rev = "c1626f5a66f28e4bc65c458f9bbc793bd5415a3a";
    hash = "sha256-dcb5osMzHffBJ0YgLNzpjye062/der3dajZ8+SY5f5U=";
  };

  buildInputs = [ elfutils udev libbpf zlib bpftools ];
  nativeBuildInputs = [ pkg-config cargo rustc meson ninja rustPlatform.cargoSetupHook buildPackages.clang.cc buildPackages.python3Packages.pytest ];

  # Don't build any BPF programs
  mesonFlags = [ "-Dbpfs=" "-Dudevdir=${placeholder "out"}/lib/udev" "-Dbpfdirs=" ];

  outputs = [ "out" "dev" ];

  postInstall = ''
    install -Dm 0644 -t "$dev/include" ../src/bpf/*.h
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-z+eNoNe5Zl4r+/Y/uXM4FJCsPSOe+pxke20UaAqaI/A=";
  };

  meta = {
    mainProgram = "udev-hid-bpf";
  };
})
