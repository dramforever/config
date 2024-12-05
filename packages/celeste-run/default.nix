{ lib, writeShellScriptBin
, SDL2, mono, coreutils
}:

writeShellScriptBin "celeste-run" ''
  if [[ $# -ne 1 ]]; then
    echo "Usage: $0 /path/to/Celeste.exe" >&2
    exit 1
  fi

  celeste="$("${lib.getExe' coreutils "dirname"}" "$1")"
  LD_LIBRARY_PATH="${lib.makeLibraryPath [ SDL2 ]}:$celeste/lib:$celeste/lib64" \
    exec "${lib.getExe' mono "mono"}" "$1"
''
