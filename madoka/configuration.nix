{ config, pkgs, lib, modulesPath, ... }:

{
  nix.package = pkgs.nixVersions.unstable;
  nix.settings.trusted-public-keys = [ "dram:/sCZAE781Fh/EDo+GYfT7eUNHrJLM1wTl+RnHXaDRps=" ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
      keyFile = "/var/lib/age-key.txt";
      sshKeyPaths = [ ];
    };

    gnupg.sshKeyPaths = [ ];

    secrets = {
      hostapd_conf = {};
      goauthing = {};
    };
  };

  documentation.nixos.enable = false;

  users.users.dram = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII2X4EKIQTUUctgGnrXhHYddKzs69hXsmEK2ePBzSIwM"
    ];
  };

  users.mutableUsers = false;

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    kernelParams = [ "console=ttyS0,115200n8" "console=tty0" ];
  };

  # For Wi-Fi support
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="dc:a6:32:a8:08:77", ATTR{type}=="1", KERNEL=="*", NAME="eth0"
    SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="dc:a6:32:a8:08:78", ATTR{type}=="1", KERNEL=="*", NAME="wlan0"
  '';

  systemd.services.hostapd = {
    description = "hostapd";

    after = [ "sys-subsystem-net-devices-wlan0.device" ];
    bindsTo = [ "sys-subsystem-net-devices-wlan0.device" ];
    requiredBy = [ "network-link-wlan0.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      LoadCredential = "hostapd.conf:${config.sops.secrets.hostapd_conf.path}";
      Restart = "always";
    };

    script = ''
      exec "${pkgs.hostapd}/bin/hostapd" "$CREDENTIALS_DIRECTORY/hostapd.conf"
    '';
  };

  networking = {
    hostName = "madoka";
    domain = "dram.page";
    useNetworkd = true;
    useDHCP = false;
    firewall.enable = false;
    timeServers = [ "ntp.tuna.tsinghua.edu.cn" ];
  };

  services.resolved.enable = true;

  systemd.network.networks = {
    eth0 = {
      name = "eth0";
      DHCP = "yes";
      dhcpV4Config.UseDNS = true;
      dhcpV6Config.UseDNS = true;
    };

    wlan0 = {
      name = "wlan0";
      address = [ "10.0.0.1/24" ];

      dhcpServerConfig = {
        PoolOffset = 100;
        PoolSize = 100;
        EmitDNS = "yes";
        DNS = [ "166.111.8.28" "166.111.8.29" "2402:f000:1:801::8:28" "2402:f000:1:801::8:29" ];
      };
      networkConfig = {
        DHCPServer = "yes";
        IPMasquerade = "ipv4";
      };
    };
  };

  services.openssh = {
    enable = true;
    listenAddresses = [
      { addr = "10.0.0.1"; port = 22; }
    ];
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    ports = [];
  };

  security.sudo.extraRules = [
    { groups = [ "wheel" ]; commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ]; }
  ];

  systemd.services.goauthing = {
    serviceConfig = {
      Type = "oneshot";
      DynamicUser = true;
      LoadCredential = "auth:${config.sops.secrets.goauthing.path}";
    };
    script = "${pkgs.goauthing}/bin/goauthing -D -c \${CREDENTIALS_DIRECTORY}/auth auth";
  };

  systemd.timers.goauthing = {
    timerConfig = {
      OnCalendar = "minutely";
    };
    wantedBy = [ "timers.target" ];
  };

  services.journald.extraConfig = ''
    Storage=volatile
  '';
}
