{ config, pkgs, ... }:

{
  nixpkgs.overlays = import ../packages/list.nix;

  environment.systemPackages = with pkgs; [
    glibc.out
    fcitx-configtool
    utillinux
    pciutils
    nvidia-offload
  ];

  programs.vim.defaultEditor = true;

  programs.mtr.enable = true;

  programs.wireshark.enable = true;

  programs.ssh = {
    startAgent = true;
  };

  environment.etc."chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json".source =
    "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    extraOptions = "--registry-mirror=https://docker.mirrors.ustc.edu.cn";
  };

  programs.command-not-found.dbPath = "/var/lib/command-not-found/programs.sqlite";
}
