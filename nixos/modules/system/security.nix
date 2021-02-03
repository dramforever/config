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

  security.pam = {
    u2f.control = "sufficient";
    u2f.cue = true;

    services.sudo.u2fAuth = true;
    services.doas.u2fAuth = true;
  };
}
