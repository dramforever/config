{ lib, stdenv
, buildPackages
, udev-hid-bpf, linuxHeaders, libbpf
, bpftools, python3
}:

{ name, src }:

stdenv.mkDerivation {
  inherit name src;

  buildInputs = [ udev-hid-bpf linuxHeaders libbpf ];
  nativeBuildInputs = [ udev-hid-bpf bpftools buildPackages.clang.cc python3 ];

  strictDeps = true;

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild
    clang -target bpf $NIX_CFLAGS_COMPILE -O2 -g -c -o "$name.bpf.unstripped.o" "$src"
    bpftool gen object "$name.bpf.o" "$name.bpf.unstripped.o"

    udev-hid-bpf inspect "$name.bpf.o" \
      | python3 ${./gen-udev-rules.py} \
          --bpfdir "$out/lib/firmware/hid/bpf" \
          --helper "${lib.getExe udev-hid-bpf}" \
      > "90-hid-bpf-$name.rules"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm 0644 -t "$out/lib/firmware/hid/bpf" "$name.bpf.o"
    install -Dm 0644 -t "$out/lib/udev/rules.d" "90-hid-bpf-$name.rules"
    runHook postInstall
  '';
}
