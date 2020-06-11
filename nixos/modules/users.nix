{ config, pkgs, ... }:

{
  users.users = {
    dram = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" "vboxusers" "docker" "wireshark" ];
    };

    hex = {
      isNormalUser = true;
      uid = 1016;
    };
  };
}
