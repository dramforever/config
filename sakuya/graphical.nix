{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "us";

    libinput.enable = true;

    displayManager.sddm = {
      enable = true;
      settings = {
        X11 = {
          ServerArguments = "-nolisten tcp -dpi 132";
          MinimumVT = 1;
        };
      };
    };

    displayManager.hiddenUsers = [ "hex" ];
    desktopManager.plasma5.enable = true;

    xkbOptions = "terminate:ctrl_alt_bksp,caps:ctrl_modifier";

    videoDrivers = [ "nvidia" ];

    # digimend.enable = true;
  };

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    offload.enable = true;
  };

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-rime ];
  };

  fonts.fonts = with pkgs; [
    sarasa-gothic
  ];

  fonts.fontDir.enable = true;

  fonts.fontconfig.defaultFonts = {
    monospace = [ "Sarasa Mono SC" ];
    sansSerif = [ "Sarasa UI SC" ];
    serif = [ "Sarasa UI SC" ];
  };
}
