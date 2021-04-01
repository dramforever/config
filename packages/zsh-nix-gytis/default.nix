# Adapted from: https://github.com/gytis-ivaskevicius/nixfiles/blob/master/overlays/shell-config/nix-completions.sh
# Supports autoloading

{ stdenvNoCC }:

stdenvNoCC.mkDerivation {
  name = "nix-zsh-gytis";
  src = ./_nix;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/zsh/site-functions
    cp $src $out/share/zsh/site-functions/_nix
  '';
}
