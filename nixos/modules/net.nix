{ config, pkgs, ... }:

{
  networking.hostName = "sakuya";
  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "random";
    ethernet.macAddress = "random";
    unmanaged = [
      "00:e0:4c:68:10:ba"
      "00:e0:4c:68:11:b1"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 12345 22000 ];

  networking.firewall.logRefusedConnections = false;

  # tcp/udp 1714-1764: KDE Connect

  networking.firewall.allowedTCPPortRanges =
    [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedUDPPortRanges =
    [ { from = 1714; to = 1764; } ];
}
