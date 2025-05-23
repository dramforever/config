{ config, pkgs, lib, ... }:

{
  time.timeZone = "Asia/Shanghai";

  # networking.timeServers = [ "ntp.tuna.tsinghua.edu.cn" ];
  networking.hostId = "99a90985";

  console = {
    earlySetup = true;
    packages = [ pkgs.terminus_font ];
    font = "ter-124n";
    keyMap = "us";
  };

  i18n.defaultLocale = "en_US.UTF-8";

  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     SATA_LINKPWR_ON_BAT = "max_performance";
  #     CPU_SCALING_GOVERNOR_ON_AC = "powersave";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #   };
  # };

  # services.usbmuxd.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  systemd.services."autovt@tty1".enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;
  hardware.bluetooth.enable = true;

  # powerManagement.cpuFreqGovernor = "powersave";

  services.fstrim = {
    enable = true;
    interval = "tuesday,friday";
  };

  services.openssh = {
    enable = true;
    ports = [ 20297 ];
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.pcscd = {
    enable = true;
    plugins = [ pkgs.ccid ];
  };

  virtualisation.libvirtd.enable = true;
}
