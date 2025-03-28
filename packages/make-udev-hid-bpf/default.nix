{ lib, stdenv
, buildPackages
, udev-hid-bpf, linuxHeaders, libbpf
, bpftools
}:

{ name, src }:

stdenv.mkDerivation {
  inherit name src;

  buildInputs = [ udev-hid-bpf linuxHeaders libbpf ];
  nativeBuildInputs = [ bpftools buildPackages.clang.cc ];

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild
    clang -target bpf $NIX_CFLAGS_COMPILE -O2 -g -c -o "$name.bpf.unstripped.o" "$src"
    bpftool gen object "$name.bpf.o" "$name.bpf.unstripped.o"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm 0644 -t "$out/lib/firmware/hid/bpf" "$name.bpf.o"
    runHook postInstall
  '';
}
