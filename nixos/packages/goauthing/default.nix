{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "goauthing";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "z4yx";
    repo = "GoAuthing";
    rev = "v${version}";
    sha256 = "12xdmjy4i4n5jzxjmmjfag0n4cpp1qiz5kzqgdxkmvyqgcjn2prd";
  };

  vendorSha256 = lib.fakeSha256;

  subPackages = [ "cli" ];

  meta = with lib; {
    description = "Command line Tunet (auth4/6.tsinghua.edu.cn, Tsinghua-IPv4) authentication tool.";
    homepage = "https://github.com/z4yx/GoAuthing";
    license = licenses.gpl3Only;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
