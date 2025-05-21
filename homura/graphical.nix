{ config, pkgs, ... }:

{
  hardware.asahi.useExperimentalGPUDriver = true;

  services = {
    libinput.enable = true;
    xserver = {
      enable = true;

      xkb = {
        layout = "us";
      };
    };

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    displayManager.hiddenUsers = [ "hex" ];
    displayManager.defaultSession = "plasma";
    desktopManager.plasma6.enable = true;

    keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "25a7:2301" ];
        settings.main = {
          capslock = "overload(control, esc)";
        };
      };
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-rime ];
  };

  fonts.packages = with pkgs; [
    sarasa-gothic
  ];

  fonts.fontDir.enable = true;

  fonts.fontconfig.defaultFonts = {
    monospace = [ "Sarasa Mono SC" ];
    sansSerif = [ "Sarasa UI SC" ];
    serif = [ "Sarasa UI SC" ];
  };

  # Vulkan HDR
  environment.systemPackages = [ pkgs.vulkan-hdr-layer-kwin6 ];
}
