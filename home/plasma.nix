{
  programs.plasma = {
    enable = true;

    resetFiles = [];

    configFile = {
      "ksmserverrc"."General"."loginMode" = "emptySession";
      "konsolerc"."Desktop Entry"."DefaultProfile" = "tmux.profile";
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      "krunnerrc"."Plugins"."baloosearchEnabled" = false;
      "kwinrc"."Wayland"."InputMethod" = "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";

      "kwinrc"."Plugins"."krohnkiteEnabled" = true;
      "kwinrc"."Script-krohnkite"."screenGapBetween" = 16;
      "kwinrc"."Script-krohnkite"."screenGapBottom" = 16;
      "kwinrc"."Script-krohnkite"."screenGapLeft" = 16;
      "kwinrc"."Script-krohnkite"."screenGapRight" = 16;
      "kwinrc"."Script-krohnkite"."screenGapTop" = 16;
      "kwinrc"."Desktops"."Number" = 3;
      "kwinrc"."Desktops"."Rows" = 1;
    };
  };
}
