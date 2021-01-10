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

  services.tlp = {
    enable = true;
    settings = {
      SATA_LINKPWR_ON_BAT = "max_performance";
    };
  };

  services.thermald.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  systemd.services."autovt@tty1".enable = false;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.bluetooth.enable = true;

  # https://www.intel.com/content/www/us/en/programmable/support/support-resources/download/drivers/dri-usb_b-lnx.html
  services.udev.extraRules = ''
    # Intel FPGA Download Cable
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6001", GROUP="hwdevel"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6002", GROUP="hwdevel"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6003", GROUP="hwdevel"

    # Intel FPGA Download Cable II
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6010", GROUP="hwdevel"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6810", GROUP="hwdevel"

    # Serial
    SUBSYSTEM=="tty", SUBSYSTEMS=="usb", ATTR{idVendor}="1a86", ATTR{idProduct}="7523", GROUP="hwdevel"

    # Xilinx
    ATTR{idVendor}=="1443", MODE:="666"
    ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"
    ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Xilinx", MODE:="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"

    # Anlogic
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0547", ATTRS{idProduct}=="1002", GROUP="hwdevel", MODE="0660"

    # CanoKey
    SUBSYSTEM!="usb", GOTO="canokeys_rules_end"
    ACTION!="add|change", GOTO="canokeys_rules_end"
    ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="42d4", ENV{ID_SMARTCARD_READER}="1"
    LABEL="canokeys_rules_end"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="42d4", GROUP="hwdevel", MODE="0660"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="42d4", TAG+="uaccess"
  '';
}
