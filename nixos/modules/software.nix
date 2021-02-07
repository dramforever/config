{ config, pkgs, ... }:

{
  documentation.dev.enable = true;

  environment.systemPackages = with pkgs; [
    fcitx-configtool
    utillinux
    pciutils
    nvidia-offload
    libimobiledevice
    usbmuxd
    nix-search
    git
  ];

  programs.vim.defaultEditor = true;

  programs.mtr.enable = true;

  programs.wireshark.enable = true;

  programs.ssh = {
    startAgent = true;
  };

  services.lorri.enable = true;

  programs.dconf.enable = true;

  environment.etc."chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json".source =
    "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";

  # virtualisation.virtualbox.host.enable = true;

  programs.command-not-found.dbPath = "${pkgs.path}/programs.sqlite";
}
