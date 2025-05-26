{ config, pkgs, ... }:

{
  networking.hostName = "homura";
  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "random";
    ethernet.macAddress = "random";
  };

  networking.firewall.allowedTCPPorts = [ 12345 22000 ];

  networking.firewall.logRefusedConnections = false;

  # tcp/udp 1714-1764: KDE Connect

  networking.firewall.allowedTCPPortRanges =
    [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedUDPPortRanges =
    [ { from = 1714; to = 1764; } ];

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
}
