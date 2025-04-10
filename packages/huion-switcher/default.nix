{ lib, fetchFromGitHub, rustPlatform
, udev
, pkg-config
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "huion-switcher";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "whot";
    repo = "huion-switcher";
    rev = "0.5.0";
    hash = "sha256-+cMvBVtJPbsJhEmOh3SEXZrVwp9Uuvx6QmUCcpenS20=";
  };

  buildInputs = [ udev ];
  nativeBuildInputs = [ pkg-config ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-yj55FMdf91ZG95yuMt3dQFhUjYM0/sUfFKB+W+5xEfo=";

  postInstall = ''
    # No longer accurate after patching below
    sed -i -e '/^# huion-switcher must live in/d' "80-huion-switcher.rules"

    # Mind the trailing space! We leave the args to huion-switcher in place
    substituteInPlace "80-huion-switcher.rules" --replace-fail \
      "IMPORT{program}=\"huion-switcher " \
      "IMPORT{program}=\"$out/bin/huion-switcher "

    install -Dm 0644 -t "$out/lib/udev/rules.d" "80-huion-switcher.rules"
  '';

  meta = {
    mainProgram = "huion-switcher";
  };
})
