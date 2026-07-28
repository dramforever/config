# @yuyuyureka said the clang build was broken as of writing :(

{
  stdenv,
  meson,
  ninja,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "avd-fw";
  version = "0";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "avd-fw";
    rev = "5e34aca83906f12ef3c2bfacb6712797de4bb7d5";
    hash = "sha256-cq/gOgmbCg5IX0GSiS7Z5lBhpursB1Num8LSANw5fpI=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "find_program('llvm-objcopy')" "find_program('${stdenv.cc.targetPrefix}objcopy')"
  '';

  nativeBuildInputs = [ meson ninja ];
}
