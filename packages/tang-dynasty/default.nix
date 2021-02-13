{ stdenv, requireFile, lib, runCommand
, autoPatchelfHook, unzip, makeWrapper
, gtk2, cairo, fontconfig, xlibs, dbus, xkeyboardconfig
}:

stdenv.mkDerivation {
  pname = "tang-dynasty";
  version = "4.6.4";
  nativeBuildInputs = [ autoPatchelfHook unzip makeWrapper ];
  buildInputs = [ gtk2 cairo fontconfig xlibs.libSM dbus ];

  src = requireFile rec {
    name = "TD_RELEASE_March2020_r4.6.4_RHEL.zip";
    url = "https://dl.sipeed.com/TANG/Primer/IDE/${name}";
    sha256 = "1g1y5p3h53c7lsdhvx89i76cgjiwciigbfs05ffpkk66q86cx534";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/opt/tang-dynasty"
    cp -r * "$out/opt/tang-dynasty"
    chmod +x "$out"/opt/tang-dynasty/bin/* "$out"/opt/tang-dynasty/lib/*.so.*
    ln -sf "/tmp/Anlogic.lic" "$out/opt/tang-dynasty/license/Anlogic.lic"
    makeWrapper "$out/opt/tang-dynasty/bin/td" "$out/bin/td" --prefix QT_XKB_CONFIG_ROOT : "${xkeyboardconfig}/share/X11/xkb"
  '';

  meta = {
    description = "IDE for Anlogic FPGA/CPLD";
    license = lib.licenses.unfree;
  };
}
