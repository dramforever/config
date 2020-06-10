{ stdenv, stdenvNoCC, kdialog }:

stdenvNoCC.mkDerivation rec {
  name = "zh-filename-fixer-${version}";
  version = "1.1.0";

  phases = [ "buildPhase" "installPhase" ];
  buildPhase = ''
    substituteAll ${./zh-filename-fixer} ./zh-filename-fixer
    zh_filename_fixer=$out/bin/zh-filename-fixer \
      substituteAll ${./zh-filename-fixer.desktop} ./zh-filename-fixer.desktop
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/kservices5/ServiceMenus
    install -m 0755 ./zh-filename-fixer $out/bin
    cp ./zh-filename-fixer.desktop $out/share/kservices5/ServiceMenus
  '';

  inherit (stdenvNoCC) shell;
  inherit kdialog;
  libc_bin = stdenv.cc.libc.bin;
}
