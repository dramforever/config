{ config, pkgs, lib, ... }:

{
  time.timeZone = "Asia/Shanghai";

  console = {
    earlySetup = true;
    packages = [ pkgs.terminus_font ];
    font = "ter-124n";
    keyMap = "us";
  };

  i18n.defaultLocale = "en_US.UTF-8";

  services.fstrim = {
    enable = true;
    interval = "tuesday";  
  };

  # powerManagement.powertop.enable = true;

  services.printing.enable = true;

  systemd.services."autovt@tty1".enable = false;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
}
