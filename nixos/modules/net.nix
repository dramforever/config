{ config, pkgs, ... }:

{
  networking.hostName = "sakuya";
  networking.networkmanager.enable = true;

  networking.networkmanager.wifi.macAddress = "random";
  networking.networkmanager.ethernet.macAddress = "random";

  networking.firewall.allowedTCPPorts = [ 12345 ];
  
  networking.firewall.logRefusedConnections = false;

  # tcp/udp 1714-1764: KDE Connect

  networking.firewall.allowedTCPPortRanges =
    [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedUDPPortRanges =
    [ { from = 1714; to = 1764; } ];
}
