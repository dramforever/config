# https://gitlab.com/NickCao/flakes/-/blob/master/pkgs/rait/default.nix
{ buildGoModule, fetchFromGitLab, lib }:

buildGoModule rec {
  pname = "rait";
  version = "2021-01-31";

  src = fetchFromGitLab {
    owner = "NickCao";
    repo = "RAIT";
    rev = "e84e803641ec3a2dce5670275ea8d5497608f483";
    hash = "sha256-vaRPmHrom4GEOuAdILzFpttc4vwcRVQWhLNalCco2qE=";
  };

  vendorSha256 = "sha256-pMltPbi1tOfxIBjLHtSxqSQUy7sMTDa8YJ9PeQp3b3k=";

  subPackages = [ "cmd/rait" ];

  meta = with lib; {
    description = "Redundant Array of Inexpensive Tunnels";
    homepage = "https://gitlab.com/NickCao/RAIT";
    license = licenses.asl20;
  };
}
