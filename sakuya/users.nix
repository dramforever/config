{ config, pkgs, ... }:

{
  users.users = {
    dram = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" "wireshark" "hwdevel" "libvirtd" "docker" ];
      shell = pkgs.zsh;
    };

    hex = {
      isNormalUser = true;
      uid = 1016;
    };
  };

  users.groups = {
    hwdevel = {};
  };
}
