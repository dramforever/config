{
  # https://github.com/NixOS/nixpkgs/pull/530382
  # https://github.com/NixOS/nixpkgs/pull/534752
  environment.pathsToLink = [ "/etc/xdg" ];
}
