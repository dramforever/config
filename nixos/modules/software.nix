{ config, pkgs, ... }:

{
  documentation.dev.enable = true;

  nix.registry.nixpkgs = {
    from = { id = "nixpkgs"; type = "indirect"; };
    to = { type = "git"; url = "file:///home/dram/code/config"; };
  };

  nix.registry.default = {
    from = { id = "default"; type = "indirect"; };
    to = { type = "git"; url = "file:///home/dram/code/config"; };
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

  programs.dconf.enable = true;

  environment.etc."chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json".source =
    "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";

  # virtualisation.virtualbox.host.enable = true;

  programs.command-not-found.dbPath = "/var/lib/nixpkgs/programs.sqlite";

  nix.package = pkgs.nixUnstable;
  nix.extraOptions =
    let flakesEmpty = pkgs.writeText "flakes-empty.json" (builtins.toJSON { flakes = []; version = 2; });
    in ''
      experimental-features = nix-command flakes
      flake-registry = ${flakesEmpty}
    '';

}
