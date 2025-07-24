{ config, pkgs, ... }:

{
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

  # Don't let sddm touch audio config
  systemd.user.services.pipewire.unitConfig.ConditionUser = "!@system";
  systemd.user.sockets.pipewire.unitConfig.ConditionUser = "!@system";
  systemd.user.services.wireplumber.unitConfig.ConditionUser = "!@system";
  systemd.user.services.wireplumber.wantedBy = [ "default.target" ];
  systemd.user.services.pipewire.wantedBy = [ "default.target" ];

  # Make sddm scale correctly
  systemd.tmpfiles.rules = [
    "d /var/lib/sddm/.config 0750 sddm sddm -"
    "C+ /var/lib/sddm/.config/kwinoutputconfig.json 0644 sddm sddm - /home/dram/.config/kwinoutputconfig.json"
  ];

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
}
