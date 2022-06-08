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
      source ${./nixenv.zsh}
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
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
    package = pkgs.gitFull;
    userEmail = "dramforever@live.com";
    userName = "dramforever";
    extraConfig = {
      init.defaultBranch = "main";
      pull.ff = "only";
      push.default = "current";
      rerere.enabled = true;
      sendemail = {
        smtpencryption = "tls";
        smtpserver = "smtp.office365.com";
        smtpuser = "dramforever@live.com";
        smtpserverport = 587;
      };
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

  services.syncthing = {
    enable = true;
  };
}
