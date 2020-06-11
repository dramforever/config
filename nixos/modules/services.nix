
{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    extraOptions = "--registry-mirror=https://docker.mirrors.ustc.edu.cn";
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
    ports = [ 20297 ];
  };
}
