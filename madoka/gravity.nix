{ config, pkgs, lib, modulesPath, ... }:

{
  environment.systemPackages = with pkgs; [
    wireguard-tools
    rait
  ];

  environment.etc."rait/rait.conf".text = ''
    # /etc/rait/rait.conf
    registry     = env("REGISTRY")
    operator_key = env("OPERATOR_KEY")
    private_key  = env("PRIVATE_KEY")

    namespace    = "gravity"

    transport {
      address_family = "ip4"
      address        = "madoka.dram.page"
      send_port      = 56133
      mtu            = 1420
      ifprefix       = "grv4x"
      ifgroup        = 54
      fwmark         = 54
      random_port    = false
    }

    transport {
      address_family = "ip6"
      address        = "madoka.dram.page"
      send_port      = 56134
      mtu            = 1400
      ifprefix       = "grv6x"
      ifgroup        = 56
      fwmark         = 56
      random_port    = false
    }

    babeld {
      enabled     = true
      socket_type = "unix"
      socket_addr = "/run/babeld.ctl"
    }

    remarks = {
      name   = "madoka"
      prefix = "2a0c:b641:69c:bab0::/60"
    }
  '';

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

  systemd.services.gravity = {
    description = "the gravity overlay network";
    serviceConfig = {
      EnvironmentFile = config.sops.secrets.rait.path;
      ExecStartPre = [
        "${pkgs.iproute}/bin/ip netns add gravity"
        "${pkgs.iproute}/bin/ip link add gravity address 00:00:00:00:00:01 type veth peer host address 00:00:00:00:00:02 netns gravity"
        "${pkgs.iproute}/bin/ip link set up gravity"
        "${pkgs.iproute}/bin/ip route add default via fe80::200:ff:fe00:2 dev gravity"
        "${pkgs.iproute}/bin/ip addr replace 2a0c:b641:69c:bab0::2/64 dev gravity"
        "${pkgs.iproute}/bin/ip -n gravity link set up lo"
        "${pkgs.iproute}/bin/ip -n gravity link set up host"
        "${pkgs.iproute}/bin/ip -n gravity addr replace 2a0c:b641:69c:bab0::1/64 dev host"
        "${pkgs.iproute}/bin/ip -n gravity route add 2a0c:b641:69c:baba::/64 via 2a0c:b641:69c:bab0::2 dev host proto static"
      ];
      ExecStart = "${pkgs.iproute}/bin/ip netns exec gravity ${pkgs.babeld}/bin/babeld -S '' -I '' -c /etc/rait/babeld.conf";
      ExecStartPost = "${pkgs.rait}/bin/rait up";
      ExecStopPost = "${pkgs.iproute}/bin/ip netns del gravity";
      ExecReload = "${pkgs.rait}/bin/rait sync";
      Restart = "always";
    };
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
  };

  services.radvd = {
    enable = false;
    config = ''
      interface wlan0 {
        AdvSendAdvert on;
        prefix 2a0c:b641:69c:baba::/64 {
          AdvOnLink on;
          AdvAutonomous on;
        };
      };
    '';
  };
}

