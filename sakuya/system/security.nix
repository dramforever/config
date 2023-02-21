{ config, pkgs, lib, ... }:

{
  security.doas = {
    enable = true;
    extraRules = lib.mkForce [
      {
        groups = [ "wheel" ];
        noPass = false;
        persist = true;
      }
    ];
  };

  security.sudo.enable = false;

  security.pam = {
    u2f.control = "sufficient";

    services.sudo.u2fAuth = true;
    services.doas.u2fAuth = true;
  };
}
