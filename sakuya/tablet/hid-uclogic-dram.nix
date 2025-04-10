{ stdenv, lib, fetchpatch, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  pname = "hid-uclogic";
  version = "${kernel.version}-dram";

  src = kernel.src;

  patches = [
    (fetchpatch {
      name = "hid-uclogic-add-256c-0064.patch";
      url = "https://lore.kernel.org/all/PH7PR20MB49624FFCDF1F9382886933D3BB1E9@PH7PR20MB4962.namprd20.prod.outlook.com/raw";
      hash = "sha256-NHKtFHRkjIJyn3yXoF0KBd3reeRj/t630piVwqzRIzM=";
    })
  ];

  postPatch = ''
    cp -rp drivers/hid/ hid-uclogic/

    # Generate relevant parts of the Makefile
    sed -e 's/$(CONFIG_HID_UCLOGIC)/m/' drivers/hid/Makefile \
      | grep hid-uclogic > hid-uclogic/Makefile
  '';

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  CROSS_COMPILE = stdenv.cc.targetPrefix;
  ARCH = stdenv.hostPlatform.linuxArch;

  makeFlags = [
    "-C${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
    "M=$(PWD)/hid-uclogic"
  ];

  installTargets = "modules_install";
}
