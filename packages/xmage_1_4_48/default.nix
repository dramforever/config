{ lib, stdenv
, fetchurl
, jdk8
, unzip
}:

stdenv.mkDerivation rec {
  name    = "xmage";
  version = "1.4.48V2";

  src = fetchurl {
    url    = "https://github.com/magefree/mage/releases/download/xmage_${version}/xmage_${version}.zip";
    hash   = "sha256-9I7eCbzNtrsQPmJQD9CInjgBLuD6y4ncrZaB1AomRc8=";
  };

  preferLocalBuild = true;

  unpackPhase = ''
    ${unzip}/bin/unzip $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -rv ./* $out

    xmage_jar=$out/mage-client/lib/mage-client-*.jar

    cat << EOS > $out/bin/xmage
exec ${jdk8}/bin/java -Xms256m -Xmx512m -XX:MaxPermSize=384m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -jar $xmage_jar
EOS

    chmod +x $out/bin/xmage
  '';

  meta = with lib; {
    description = "Magic Another Game Engine";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    homepage = "http://xmage.de/";
  };

}

