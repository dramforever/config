{ config, pkgs, lib, ... }:

{
  services.xserver.wacom.enable = true;

  services.udev.extraRules = ''
    ACTION!="add", GOTO="tablet_end"
    SUBSYSTEM=="usb", ATTR{idVendor}=="256c", ATTR{idProduct} == "0064", RUN+="${lib.getExe pkgs.hid-bpf-uclogic} --device $sys$devpath"
    LABEL="tablet_end"
  '';
}
