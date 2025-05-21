{ config, pkgs, ... }:

{
  users.users = {
    dram = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" "wireshark" "hwdevel" "libvirtd" ];
      shell = pkgs.zsh;
      hashedPassword = "$y$j9T$b/7eF0GVXQf6.0.kxvyRm.$Dlm2o5um7Fv0zPxj1B/C6vkmspTDR.Y3wM6UJIeIPQB";
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
