{ config, pkgs, lib, ... }:

{
  security.pam = {
    u2f.control = "sufficient";

    services.sudo.u2fAuth = true;
  };
}
