{ lib, ... }:

{
  environment.persistence."/.subvols/@p-root" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  environment.persistence."/.subvols/@p-home" = {
    hideMounts = true;
    users.dram.directories = [
      "Downloads"
      "tmp"
      "src"
      "code"
      ".cache"
    ];
  };

  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir -p /subvols
    mount /dev/disk/by-label/homura-root /subvols

    impermanence_clean() {
      local stamp="$(date --date="@$(stat -c '%Y' "/subvols/@$1")" "+%Y-%m-%d-%H-%M-%S")"
      local dev="$(stat -c '%d' "/subvols/@$1")"
      mkdir -p "/subvols/old-$1"
      mv "/subvols/@$1" "/subvols/old-$1/@$1-$dev_$stamp"
      btrfs subvolume create "/subvols/@$1"
    }

    impermanence_clean root

    umount /subvols
  '';
}
