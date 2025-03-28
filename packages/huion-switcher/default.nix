{ lib, fetchFromGitHub, rustPlatform
, udev
, pkg-config
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "huion-switcher";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "whot";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-+cMvBVtJPbsJhEmOh3SEXZrVwp9Uuvx6QmUCcpenS20=";
  };

  buildInputs = [ udev ];
  nativeBuildInputs = [ pkg-config ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-yj55FMdf91ZG95yuMt3dQFhUjYM0/sUfFKB+W+5xEfo=";

  meta = {
    mainProgram = "huion-switcher";
  };
})
