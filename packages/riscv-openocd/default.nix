{ fetchFromGitHub
, stdenv
, lib
, autoreconfHook
, pkg-config
, hidapi
, libftdi1
, libusb1
, libgpiod
, which
, libtool
, automake
, autoconf
}:

stdenv.mkDerivation rec {
  pname = "riscv-openocd";
  version = "0";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = "riscv-openocd";
    rev = "8488e4e863f6a465189d7dd3e6d94ccc4c493eb4";
    fetchSubmodules = true;
    hash = "sha256-N5LsGqY4YJg9fW+XVflzshq69JD8YENvZjmmyzVXKzI=";
  };

  nativeBuildInputs = [ pkg-config which libtool automake autoconf ];
  buildInputs = [ hidapi libftdi1 libusb1 libgpiod ];
  preConfigure = ''
    ./bootstrap
  '';
  configureFlags = [
    "--enable-jtag_vpi"
    "--enable-usb_blaster_libftdi"
    (lib.enableFeature (! stdenv.isDarwin) "amtjtagaccel")
    (lib.enableFeature (! stdenv.isDarwin) "gw16012")
    "--enable-presto_libftdi"
    "--enable-openjtag_ftdi"
    (lib.enableFeature (! stdenv.isDarwin) "oocd_trace")
    "--enable-buspirate"
    (lib.enableFeature stdenv.isLinux "sysfsgpio")
    (lib.enableFeature stdenv.isLinux "linuxgpiod")
    "--enable-remote-bitbang"
  ];
  SKIP_SUBMODULE = true;
  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [
    "-Wno-error=cpp"
    "-Wno-error=strict-prototypes" # fixes build failure with hidapi 0.10.0
  ];
  postInstall = lib.optionalString stdenv.isLinux ''
    mkdir -p "$out/etc/udev/rules.d"
    rules="$out/share/openocd/contrib/60-openocd.rules"
    if [ ! -f "$rules" ]; then
        echo "$rules is missing, must update the Nix file."
        exit 1
    fi
    ln -s "$rules" "$out/etc/udev/rules.d/"
  '';
  enableParallelBuilding = true;
  meta = with lib; {
    description = "Free and Open On-Chip Debugging, In-System Programming and Boundary-Scan Testing";
    longDescription = ''
      OpenOCD provides on-chip programming and debugging support with a layered
      architecture of JTAG interface and TAP support, debug target support
      (e.g. ARM, MIPS), and flash chip drivers (e.g. CFI, NAND, etc.).  Several
      network interfaces are available for interactiving with OpenOCD: HTTP,
      telnet, TCL, and GDB.  The GDB server enables OpenOCD to function as a
      "remote target" for source-level debugging of embedded systems using the
      GNU GDB program.
    '';
    homepage = "https://openocd.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bjornfor prusnak ];
    platforms = platforms.unix;
  };
}

