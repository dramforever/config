{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wireguard-tools
    rait
  ];

  environment.etc."rait/babeld.conf".text = ''
    random-id true
    export-table 254
    local-path-readwrite /run/babeld.ctl

    # to make babeld happy
    interface foo

    redistribute ip 2a0c:b641:690::/44 ge 64 le 64 allow
    redistribute local deny
  '';

  # networking.firewall.enable = false;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;
  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="dc:a6:32:a8:08:77", ATTR{type}=="1", KERNEL=="*", NAME="lan0"
  '';
  networking.interfaces.lan0.ipv6.addresses = [
    {
      address = "2a0c:b641:69c:baba::1";
      prefixLength = 64;
    }
  ];

  # https://gitlab.com/NickCao/flakes/-/blob/master/nixos/configuration.nix#L225
  systemd.services.gravity = {
    description = "the gravity overlay network";
    serviceConfig = {
      ExecStartPre = "${pkgs.iproute}/bin/ip netns add gravity";
      ExecStopPost = "${pkgs.iproute}/bin/ip netns del gravity";
      ExecStart =
        "${pkgs.iproute}/bin/ip netns exec gravity ${pkgs.babeld}/bin/babeld -S '' -I '' -c /etc/rait/babeld.conf";
      ExecStartPost = [
        "${pkgs.rait}/bin/rait up"
        "${pkgs.iproute}/bin/ip link add gravity address 00:00:00:00:00:01 type veth peer host address 00:00:00:00:00:02 netns gravity"
        "${pkgs.iproute}/bin/ip link set up gravity"
        "${pkgs.iproute}/bin/ip route add default via fe80::200:ff:fe00:2 dev gravity"
        "${pkgs.iproute}/bin/ip addr replace 2a0c:b641:69c:bab0::2/64 dev gravity"
        "${pkgs.iproute}/bin/ip -n gravity link set up lo"
        "${pkgs.iproute}/bin/ip -n gravity link set up host"
        "${pkgs.iproute}/bin/ip -n gravity addr replace 2a0c:b641:69c:bab0::1/64 dev host"
        "${pkgs.iproute}/bin/ip -n gravity route add 2a0c:b641:69c:baba::/64 via 2a0c:b641:69c:bab0::2 dev host proto static"
      ];
      ExecReload = "${pkgs.rait}/bin/rait sync";
    };
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
  };


}
