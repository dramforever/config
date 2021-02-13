{ pkgs, ... }:

{
  imports = [
    ./rpi4.nix
  ];

  networking.hostName = "madoka";

  environment.systemPackages = with pkgs; [ wpa_supplicant libraspberrypi ];

  programs.vim.defaultEditor = true;

  services.sshd.enable = true;

  nix.binaryCaches = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

  nix.gc = {
    automatic = true;
    dates = "sunday";
    options = "--delete-older-than 8d";
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };

    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
}
