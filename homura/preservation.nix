{
  preservation.enable = true;

  preservation.preserveAt."/.subvols/@p-root" = {
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      { file = "/etc/machine-id"; inInitrd = true; }
    ];
  };

  # https://github.com/NixOS/nixpkgs/pull/351151
  systemd.services.systemd-machine-id-commit.enable = false;
}
