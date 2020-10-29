{ config, pkgs, ... }:

{
  documentation.dev.enable = true;

  nix.registry.nixpkgs = {
    from = { id = "nixpkgs"; type = "indirect"; };
    to = { path = "/home/dram/code/config/nixos"; type = "path"; };
  };

  environment.systemPackages = with pkgs; [
    fcitx-configtool
    utillinux
    pciutils
    nvidia-offload
    libimobiledevice
    usbmuxd
  ];

  programs.vim.defaultEditor = true;

  programs.mtr.enable = true;

  programs.wireshark.enable = true;

  programs.ssh = {
    startAgent = true;
  };

  services.lorri.enable = true;

  environment.etc."chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json".source =
    "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";

  # virtualisation.virtualbox.host.enable = true;

  programs.command-not-found.dbPath = "/var/lib/nixpkgs/programs.sqlite";

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

}
