# https://gitlab.com/NickCao/flakes/-/blob/master/pkgs/rait/default.nix
{ buildGoModule, fetchFromGitLab, lib }:

buildGoModule rec {
  pname = "rait";
  version = "2021-01-31";

  src = fetchFromGitLab {
    owner = "NickCao";
    repo = "RAIT";
    rev = "6d26eef1389c391b71cf5aad4bd64570462d5378"; # heads/master
    sha256 = "18ahpsfisf21zaw3jc1k82nc57i58cvy294k2dfw02wxqh99p3ml";
  };

  vendorSha256 = "sha256-55Zu1g+pwTt6dU1QloxfFkG2dbnK5gg84WvRhz2ND3M=";

  subPackages = [ "cmd/rait" ];

  meta = with lib; {
    description = "Redundant Array of Inexpensive Tunnels";
    homepage = "https://gitlab.com/NickCao/RAIT";
    license = licenses.asl20;
  };
}
