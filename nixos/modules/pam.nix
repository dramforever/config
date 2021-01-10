{ config, pkgs, ... }:

{
  security.pam = {
    u2f.control = "sufficient";
    u2f.cue = true;
    services.sudo.u2fAuth = true;
  };
}
