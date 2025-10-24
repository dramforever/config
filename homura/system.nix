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

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75; # Unused on Apple Silicon
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # Not supported (yet?) on Apple Silicon
  services.power-profiles-daemon.enable = false;

  # services.usbmuxd.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  systemd.services."autovt@tty1".enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  systemd.services.rtkit-daemon.serviceConfig.PrivateUsers = lib.mkForce false;

  systemd.package = pkgs.systemd-udev-wldN;

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
