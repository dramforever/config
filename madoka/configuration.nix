{ config, pkgs, lib, modulesPath, ... }:

{
  nix.package = pkgs.nixVersions.latest;
  nix.settings.trusted-public-keys = [ "dram:/sCZAE781Fh/EDo+GYfT7eUNHrJLM1wTl+RnHXaDRps=" ];

  time.timeZone = "Asia/Shanghai";

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
      keyFile = "/var/lib/age-key.txt";
      sshKeyPaths = [ ];
    };

    gnupg.sshKeyPaths = [ ];

    secrets = {
      hostapd_conf = {};
      gandi_auth_header = {};
    };
  };

  documentation.nixos.enable = false;

  users.users.dram = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII2X4EKIQTUUctgGnrXhHYddKzs69hXsmEK2ePBzSIwM"
    ];
    hashedPassword = "$6$bwYzFNAe7bZnxzAI$u3WlS7BKOx8gGAR8Qlw6SkvrojvJKz2BpKgZLxr41BUzAFt24LeB1zwywgxMwUbC7nI5H4I0OQKF3Txdo8JKI.";
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
  services.resolved.dnssec = "false";

  systemd.network.networks = {
    eth0 = {
      name = "eth0";
      DHCP = "ipv4";
      networkConfig = {
        IPv4Forwarding = "yes";
      };
      dhcpV4Config.UseDNS = true;
    };

    wlan0 = {
      name = "wlan0";
      address = [ "10.0.0.1/24" "2a0c:b641:69c:baba::1/64" ];

      dhcpServerConfig = {
        PoolOffset = 100;
        PoolSize = 100;
        EmitDNS = "yes";
        DNS = [ "210.77.16.1" ];
      };
      networkConfig = {
        DHCPServer = "yes";
        IPMasquerade = "ipv4";
      };
    };
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    ports = [ 25519 ];
  };

  security.sudo.extraRules = [
    { groups = [ "wheel" ]; commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ]; }
  ];

  systemd.services.gandi-ddns = {
    serviceConfig = {
      Type = "oneshot";
      DynamicUser = true;
      LoadCredential = "gandi_auth_header:${config.sops.secrets.gandi_auth_header.path}";
    };
    path = with pkgs; [ iproute2 jq curl ];
    script = builtins.readFile ./gandi.sh;
  };

  systemd.timers.gandi-ddns = {
    timerConfig = {
      OnCalendar = "hourly";
    };
    wantedBy = [ "timers.target" ];
  };

  systemd.services.restart-hostapd = {
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      systemctl restart hostapd.service
    '';
  };

  systemd.timers.restart-hostapd = {
    timerConfig = {
      OnCalendar = "04:00";
    };
    wantedBy = [ "timers.target" ];
  };

  services.journald.extraConfig = ''
    Storage=volatile
  '';

  environment.systemPackages = with pkgs; [
    iw
  ];
}
