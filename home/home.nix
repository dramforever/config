{ pkgs, lib, config, ... }:

{
  imports = [
    ./packages.nix
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    history = {
      path = "${config.xdg.cacheHome}/zsh_history";
      save = 1000000;
    };
    initExtra = ''
      source ${./zshrc}
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g mouse on
      bind % split-window -h -c "#{pane_current_path}"
      bind "\"" split-window -v -c "#{pane_current_path}"
    '';
    historyLimit = 1000000;
  };
}
