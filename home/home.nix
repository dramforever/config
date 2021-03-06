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
    nix-direnv.enableFlakes = true;
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

  systemd.user.sessionVariables = {
    GOOGLE_DEFAULT_CLIENT_ID = "77185425430.apps.googleusercontent.com";
    GOOGLE_DEFAULT_CLIENT_SECRET = "OTJgUOQcT7lO7GsGZq2G4IlT";
  };

  programs.git = {
    enable = true;
    userEmail = "dramforever@live.com";
    userName = "dramforever";
    extraConfig = {
      init.defaultBranch = "main";
      pull.ff = "only";
    };
  };

  programs.vim = {
    enable = true;

    extraConfig = ''
      nmap <Space> <Space> :update<CR>
      nmap <Space>q :q<CR>
      set hls
    '';

    settings = {
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      number = true;
      undofile = true;
      undodir = [ "${config.xdg.cacheHome}/vim/undodir" ];
    };

    plugins = [ pkgs.vimPlugins.vim-bracketed-paste ];
  };
}
