{ config, pkgs, ... }:

{
  documentation.dev.enable = true;

  environment.systemPackages = with pkgs; [
    man-pages
    utillinux
    pciutils
    nvidia-offload
    # libimobiledevice
    # usbmuxd
    nix-search
    git
    zsh-nix-fix
    config.boot.kernelPackages.perf
  ];

  programs.vim.defaultEditor = true;

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

  # services.lorri.enable = true;
  # services.flatpak.enable = true;

  programs.dconf.enable = true;

  environment.etc."chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json".source =
    "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";

  # virtualisation.virtualbox.host.enable = true;

  programs.command-not-found.enable = false;
}
