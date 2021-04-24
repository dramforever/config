{ config, pkgs, lib, ... }:

{
  imports = [
    ./system/btrbk.nix
    ./system/nix.nix
    ./system/udev.nix
    ./system/security.nix
  ];

  time.timeZone = "Asia/Shanghai";

  networking.timeServers = [ "ntp.tuna.tsinghua.edu.cn" ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

  services.usbmuxd.enable = true;
  services.thermald.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  systemd.services."autovt@tty1".enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.bluetooth.enable = true;

  powerManagement.cpuFreqGovernor = "schedutil";

  services.fstrim = {
    enable = true;
    interval = "tuesday,friday";
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

  virtualisation.kvmgt.enable = true;
  virtualisation.libvirtd.enable = true;
 }
