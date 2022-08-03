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
    grub.device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-0";
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
    permitRootLogin = "yes";
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
  };

  users = {
    mutableUsers = false;
    users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII2X4EKIQTUUctgGnrXhHYddKzs69hXsmEK2ePBzSIwM"
    ];
  };

  mailserver = {
    enable = true;
    fqdn = "kuriko.dram.page";
    domains = [ "dram.page" ];

    loginAccounts = {
        "uwu@dram.page" = {
            hashedPasswordFile = config.sops.secrets.mail_password.path;
            aliases = ["postmaster@dram.page"];
        };
    };

    certificateScheme = 3;

    hierarchySeparator = "/";
    useFsLayout = true;
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "dramforever@live.com";

  nix.settings.trusted-public-keys = [ "dram:/sCZAE781Fh/EDo+GYfT7eUNHrJLM1wTl+RnHXaDRps=" ];

  system.stateVersion = "21.11";
}
