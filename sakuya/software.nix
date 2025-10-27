{ config, pkgs, ... }:

{
  documentation.dev.enable = true;

  environment.systemPackages = with pkgs; [
    man-pages
    util-linux
    pciutils
    nvidia-offload
    # nix-search
    git
    zsh-nix-fix
    perf
  ];

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  programs.mtr.enable = true;

  programs.wireshark.enable = true;

  programs.zsh = {
    enable = true;
  };

  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };

  programs.dconf.enable = true;

  environment.etc."chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json".source =
    "${pkgs.kdePackages.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";

  programs.command-not-found.enable = false;

  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings.registry-mirrors = [ "https://docker.m.daocloud.io" ];
}
