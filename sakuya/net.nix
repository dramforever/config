{ config, pkgs, ... }:

{
  networking.hostName = "sakuya";
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

  networking.networkmanager.unmanaged = [ "enp58s0u1u4" ];
}
