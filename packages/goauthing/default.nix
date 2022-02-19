{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "goauthing";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "z4yx";
    repo = "GoAuthing";
    rev = "v${version}";
    hash = "sha256-xvYmtgwAeZF5J9+dv2TCgQeuqOQI3/AiSR7n6FQivoE=";
  };

  vendorSha256 = "sha256-LSGyy4i4JWopX54wWXZwEtRQfijCgA618FeQErwdy8o=";

  subPackages = [ "cli" ];

  postInstall = "mv $out/bin/cli $out/bin/goauthing";

  meta = with lib; {
    description = "Command line Tunet (auth4/6.tsinghua.edu.cn, Tsinghua-IPv4) authentication tool.";
    homepage = "https://github.com/z4yx/GoAuthing";
    license = licenses.gpl3Only;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
