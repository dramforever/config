{ pkgs, lib, config, ... }:

{
  home.packages = [ pkgs.dramPackagesEnv ];
}
