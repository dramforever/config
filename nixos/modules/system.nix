{ config, pkgs, lib, ... }:

{
  imports = [
    ./system/btrbk.nix
    ./system/nix.nix
    ./system/udev.nix
  ];

  time.timeZone = "Asia/Shanghai";

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
      SATA_LINKPWR_ON_BAT = "max_performance";
    };
  };

  services.usbmuxd.enable = true;
  services.thermald.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  systemd.services."autovt@tty1".enable = false;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.bluetooth.enable = true;

  services.fstrim = {
    enable = true;
    interval = "tuesday";
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    extraOptions = "--registry-mirror=https://docker.mirrors.ustc.edu.cn";
  };

  services.openssh = {
    enable = true;
    # passwordAuthentication = false;
    challengeResponseAuthentication = false;
    ports = [ 20297 ];
  };

  services.pcscd = {
    enable = true;
    plugins = [ pkgs.ccid ];
  };

  security.pam = {
    u2f.control = "sufficient";
    u2f.cue = true;
    services.sudo.u2fAuth = true;
  };
}
