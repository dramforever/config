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

    displayManager.plasma-login-manager.enable = true;

    displayManager.hiddenUsers = [ "hex" ];
    displayManager.defaultSession = "plasma";
    desktopManager.plasma6.enable = true;
  };

  # Make plasma-login-manager scale correctly
  systemd.tmpfiles.rules = [
    "d /var/lib/plasmalogin/.config 0750 plasmalogin plasmalogin -"
    "C+ /var/lib/plasmalogin/.config/kwinoutputconfig.json 0644 plasmalogin plasmalogin - /home/dram/.config/kwinoutputconfig.json"
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-rime ];
    fcitx5.waylandFrontend = true;
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
