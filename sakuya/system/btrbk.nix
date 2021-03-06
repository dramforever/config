{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.btrbk ];

  systemd.services.btrbk = {
    description = "btrbk backup";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.btrbk}/bin/btrbk run";
    };
  };

  systemd.timers.btrbk = {
    description = "btrbk backup periodic";
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnUnitInactiveSec = "15min";
      OnBootSec = "15min";
    };
  };

  environment.etc."btrbk/btrbk.conf".text = ''
    timestamp_format        long
    snapshot_preserve_min   6h
    snapshot_preserve       48h 20d 6m

    volume /.subvols
      snapshot_dir btrbk_snapshots
      subvolume @home
      snapshot_create onchange
  '';

}
