{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "us";

    libinput.enable = true;

    displayManager.sddm = {
      enable = true;
      extraConfig = ''
        [X11]
        ServerArguments=-nolisten tcp -dpi 120
        MinimumVT=1
      '';
    };

    desktopManager.plasma5.enable = true;

    xkbOptions = "terminate:ctrl_alt_bksp,caps:ctrl_modifier";

    videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    offload.enable = true;
  };

  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ libpinyin rime ];
  };

  fonts.fonts = with pkgs; [
    sarasa-gothic
  ];

  fonts.enableFontDir = true;

  fonts.fontconfig.defaultFonts = {
    monospace = [ "Sarasa Mono SC" ];
    sansSerif = [ "Sarasa UI SC" ];
    serif = [ "Sarasa UI SC" ];
  };
}
