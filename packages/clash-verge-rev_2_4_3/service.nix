{
  rustPlatform,
  fetchFromGitHub,
  meta,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clash-verge-service-ipc";
  version = "2.0.21";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service-ipc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9c9fM1l31NbY//Ri50Ql60BWWgISjMWj72ABixRaXvM=";
  };

  postPatch = ''
    substituteInPlace src/lib.rs \
      --replace-fail "/tmp/verge/clash-verge-service.sock" "/run/clash-verge-rev/service.sock"
  '';

  cargoHash = "sha256-UbNN3uFu5anQV+3KMFPNnGrCDQTGb4uC9K83YghfQgY=";
  buildFeatures = [
    "standalone"
  ];
  # tests are broken
  dontCargoCheck = true;
  inherit meta;
})
