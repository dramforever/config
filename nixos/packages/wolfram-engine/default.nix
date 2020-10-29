# Credit goes to https://gist.github.com/LEXUGE/02ea46b28ed56d6890306267a44576f4

{ stdenv, coreutils, patchelf, requireFile, callPackage, makeWrapper, alsaLib
, dbus, fontconfig, freetype, gcc, glib, libssh2, ncurses, opencv, openssl
, unixODBC, xkeyboard_config, xorg, zlib, libxml2, libuuid, lang ? "en", libGL
, libGLU, fetchurl, fakeroot, buildFHSUserEnv, dbus_libs, runCommand }:

let
  wolfram-engine = stdenv.mkDerivation rec {
    version = "12.1";
    pname = "wolfram-engine";
    src = fetchurl {
      url =
        "https://account.wolfram.com/download/public/wolfram-engine/desktop/LINUX";
      sha256 = "1p7rhjzrl7k141c8kns007rf6088xpcyh8q8pkji5nshfmlqja25";
    };

    nativeBuildInputs = [ fakeroot ];

    buildInputs = [
      coreutils
      patchelf
      makeWrapper
      alsaLib
      dbus
      fontconfig
      freetype
      gcc.cc
      gcc.libc
      glib
      libssh2
      ncurses
      opencv
      openssl
      stdenv.cc.cc.lib
      unixODBC
      xkeyboard_config
      libxml2
      libuuid
      zlib
      libGL
      libGLU
    ] ++ (with xorg; [
      libX11
      libXext
      libXtst
      libXi
      libXmu
      libXrender
      libxcb
      libXcursor
      libXfixes
      libXrandr
      libICE
      libSM
    ]);

    ldpath = stdenv.lib.makeLibraryPath buildInputs
      + stdenv.lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux")
      (":" + stdenv.lib.makeSearchPathOutput "lib" "lib64" buildInputs);

    unpackPhase = ''
      echo "=== Extracting makeself archive ==="
      # find offset from file
      offset=$(${stdenv.shell} -c "$(grep -axm1 -e 'offset=.*' $src); echo \$offset" $src)
      dd if="$src" ibs=$offset skip=1 | tar -xf -
      cd Unix
    '';

    installPhase = ''
      cd Installer

      # don't restrict PATH, that has already been done
      sed -i -e 's/^PATH=/# PATH=/' MathInstaller
      sed -i -e 's/\/bin\/bash/\/bin\/sh/' MathInstaller
      sed -i -e 's/unxz/unxz -T2/' MathInstaller

      echo "=== Running MathInstaller ==="
      fakeroot ./MathInstaller -auto -createdir=y -execdir=$out/bin -targetdir=$out/libexec/Mathematica

      # Fix library paths
      cd $out/libexec/Mathematica/Executables
      for path in math MathKernel mcc WolframKernel wolfram wolframplayer WolframPlayer; do
        sed -i -e "2iexport LD_LIBRARY_PATH=${zlib}/lib:${stdenv.cc.cc.lib}/lib:${libssh2}/lib:\''${LD_LIBRARY_PATH}\n" $path
      done

      # Fix xkeyboard config path for Qt
      for path in wolframplayer WolframPlayer; do
        sed -i -e "2iexport QT_XKB_CONFIG_ROOT=\"${xkeyboard_config}/share/X11/xkb\"\n" $path
      done

      # Remove some broken libraries
      rm -f $out/libexec/Mathematica/SystemFiles/Libraries/Linux-x86-64/libz.so*

      # Set environment variable to fix libQt errors - see https://github.com/NixOS/nixpkgs/issues/96490
      wrapProgram $out/libexec/Mathematica/Executables/WolframPlayer --set USE_WOLFRAM_LD_LIBRARY_PATH 1 --prefix PATH : ${coreutils}/bin
    '';

    preFixup = ''
          echo "=== PatchElfing away ==="
          # This code should be a bit forgiving of errors, unfortunately
          set +e
          find $out/libexec/Mathematica/SystemFiles -type f -perm -0100 | while read f; do
            type=$(readelf -h "$f" 2>/dev/null | grep 'Type:' | sed -e 's/ *Type: *\([A-Z]*\) (.*/\1/')
            if [ -z "$type" ]; then
              :
            elif [ "$type" == "EXEC" ]; then
              echo "patching $f executable <<"
              patchelf --shrink-rpath "$f"
              patchelf \
      	  --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                --set-rpath "$(patchelf --print-rpath "$f"):${ldpath}" \
                "$f" \
                && patchelf --shrink-rpath "$f" \
                || echo unable to patch ... ignoring 1>&2
            elif [ "$type" == "DYN" ]; then
              echo "patching $f library <<"
              patchelf \
                --set-rpath "$(patchelf --print-rpath "$f"):${ldpath}" \
                "$f" \
                && patchelf --shrink-rpath "$f" \
                || echo unable to patch ... ignoring 1>&2
            else
              echo "not patching $f <<: unknown elf type"
            fi
          done
        '';

    dontBuild = true;

    # all binaries are already stripped
    dontStrip = true;

    # we did this in prefixup already
    dontPatchELF = true;

  };

  env = buildFHSUserEnv {
    name = "${wolfram-engine.name}-env";
    targetPkgs = pkgs': [ wolfram-engine dbus_libs ];
    runScript = "";
  };

in runCommand wolfram-engine.name {
  nativeBuildInputs = [ makeWrapper ];
} ''
  mkdir -p "$out/bin"
  for i in "${wolfram-engine}/libexec/Mathematica/Executables/"* "${wolfram-engine}/libexec/Mathematica/SystemFiles/Kernel/Binaries/Linux-x86-64/"*; do
    base="$(basename "$i")"
    echo "Wrapping $base"
    makeWrapper ${env}/bin/${env.name} "$out/bin/$base" --add-flags "$i"
  done
''
