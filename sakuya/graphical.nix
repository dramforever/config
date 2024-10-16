{ config, pkgs, ... }:

{
  services = {
    libinput.enable = true;
    xserver = {
      enable = true;
      digimend.enable = true;
      videoDrivers = [ "nvidia" ];

      xkb = {
        layout = "us";
        options = "terminate:ctrl_alt_bksp,caps:ctrl_modifier";
      };
    };

    xserver.displayManager.gdm = {
      enable = true;
    };

    displayManager.hiddenUsers = [ "hex" ];
    desktopManager.plasma6.enable = true;
  };

  hardware.nvidia.open = true;

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    offload.enable = true;
  };

  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-rime ];
  };

  # https://codereview.qt-project.org/c/qt/qtbase/+/597856
  environment.variables.QT_PLUGIN_PATH =
    let
      fcitx5Workaround = pkgs.runCommand "fcitx5-workaround" {} ''
        plugins="${config.i18n.inputMethod.package}/${pkgs.qt6.qtbase.qtPluginPrefix}"
        cp -r --dereference "$plugins" $out
      '';
    in [ "${fcitx5Workaround}" ];

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
