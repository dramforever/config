{
  services.btrbk.instances.snapshot = {
    onCalendar = "*:0/15";
    settings = {
      timestamp_format = "long-iso";
      snapshot_preserve_min = "6h";
      snapshot_preserve = "48h 20d 6m";
      volume."/.subvols" = {
        snapshot_dir = "btrbk";
        snapshot_create = "onchange";
        subvolume = "@home";
      };
    };
  };
}
