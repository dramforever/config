{ config, pkgs, lib, ... }:

{
  services.xserver.wacom.enable = true;

  # huion-switcher udev rules
  services.udev.extraRules =
    let
      gaomon-m7-bpf-pkg = pkgs.make-udev-hid-bpf {
        name = "0010-Gaomon__M7";
        src = ./tablet/0010-Gaomon__M7.bpf.c;
      };
      gaomon-m7-bpf = "${gaomon-m7-bpf-pkg}/lib/firmware/hid/bpf/${gaomon-m7-bpf-pkg.name}.bpf.o";
    in ''
      ACTION!="add|remove|bind", GOTO="huion_switcher_end"
      ATTRS{idVendor}=="256c", IMPORT{program}="${lib.getExe pkgs.huion-switcher} %S%p"
      ATTRS{idVendor}=="256c", ENV{HID_UNIQ}=="", ENV{HUION_FIRMWARE_ID}!="", ENV{HID_UNIQ}="$env{HUION_FIRMWARE_ID}"
      ATTRS{idVendor}=="256c", ENV{UNIQ}=="", ENV{HUION_FIRMWARE_ID}!="", ENV{UNIQ}="$env{HUION_FIRMWARE_ID}"
      LABEL="huion_switcher_end"

      ACTION!="add|remove|bind", GOTO="gaomon_m7_hid_bpf_end"
      SUBSYSTEM!="hid", GOTO="gaomon_m7_hid_bpf_end"

      ATTRS{idVendor}=="256c", ATTRS{idProduct}=="0064", ACTION=="add", RUN{program}+="${lib.getExe pkgs.udev-hid-bpf} add $sys$devpath - ${gaomon-m7-bpf}"
      ATTRS{idVendor}=="256c", ATTRS{idProduct}=="0064", ACTION=="remove", RUN{program}+="${lib.getExe pkgs.udev-hid-bpf} remove $sys$devpath"

      LABEL="gaomon_m7_hid_bpf_end"
    '';
}
