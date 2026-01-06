{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
      keyFile = "/var/lib/age-key.txt";
      sshKeyPaths = [ ];
    };

    gnupg.sshKeyPaths = [ ];

    secrets = {
      mail_password = {};
    };
  };

  boot.initrd.availableKernelModules = [ "ahci" "virtio_pci" "xhci_hcd" "sd_mod" "sr_mod" ];

  boot.loader = {
    grub.enable = true;
    grub.device = "/dev/disk/by-path/pci-0000:06:00.0-scsi-0:0:0:0";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/kuriko-nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/kuriko-boot";
    fsType = "vfat";
  };

  networking.useDHCP = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users = {
    mutableUsers = false;
    users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHc0D3VK/Eg0XeZ34h2u8GQ49/nRG6NBS00mZfFDtbWD"
    ];
    users.dram = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHc0D3VK/Eg0XeZ34h2u8GQ49/nRG6NBS00mZfFDtbWD"
      ];
    };
  };

  mailserver = {
    enable = true;
    localDnsResolver = false;
    fqdn = "kuriko.dram.page";
    domains = [ "dram.page" ];

    loginAccounts = {
      "uwu@dram.page" = {
          hashedPasswordFile = config.sops.secrets.mail_password.path;
          aliases = ["postmaster@dram.page"];
      };
    };

    x509.useACMEHost = config.mailserver.fqdn;

    hierarchySeparator = "/";
    useFsLayout = true;
    stateVersion = 3;
  };

  services.nginx = {
    enable = true;
    virtualHosts."${config.mailserver.fqdn}" = {
      forceSSL = true;
      enableACME = true;
    };
  };

  security.acme.certs."${config.mailserver.fqdn}" = {
    reloadServices = [
      "postfix.service"
      "dovecot.service"
    ];
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "dramforever@live.com";

  security.acme.defaults.postRun = lib.getExe (pkgs.writeShellApplication {
    name = "acme-email-notify";
    text = ''
      /run/wrappers/bin/su -c '${lib.getExe pkgs.openssl} x509 -text -noout | ${lib.getExe' pkgs.mailutils "mail"} -s "Certificate renewed" "uwu@dram.page"' dram < cert.pem
    '';
  });

  security.sudo.wheelNeedsPassword = false;

  services.znc = {
    enable = true;
    mutable = true;
    useLegacyConfig = false;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 1d";
    };

    nixPath = [ "nixpkgs=/home/dram/code/config" ];

    package = pkgs.nix-dram;

    settings =
      let flakesEmpty = pkgs.writeText "flakes-empty.json" (builtins.toJSON { flakes = []; version = 2; });
      in {
        trusted-users = [ "root" "dram" ];
        experimental-features = [ "nix-command" "flakes" ];
        default-flake = "github:NixOS/nixpkgs/nixos-unstable";
        flake-registry = flakesEmpty;
        auto-optimise-store = true;
        trusted-public-keys = [ "dram:/sCZAE781Fh/EDo+GYfT7eUNHrJLM1wTl+RnHXaDRps=" ];
      };
  };

  system.stateVersion = "21.11";
}
