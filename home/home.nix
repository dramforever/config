{ pkgs, lib, config, ... }:

{
  imports = [
    ./packages.nix
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    dotDir = "${config.xdg.configHome}/.config/zsh";
    history = {
      path = "${config.xdg.cacheHome}/zsh_history";
      save = 1000000;
    };
    initContent = ''
      source ${./zshrc}
      source ${./nixenv.zsh}
      # source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh
    '';
  };

  home.sessionVariables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    NIXOS_OZONE_WL = 1;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
    colors = {
      "bg+" = "black";
      "hl" = "black:reverse";
      "hl+" = "white:dim:reverse";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv.override {
        nix = pkgs.nix-dram;
      };
    };
    config = {
      hide_env_diff = true;
    };
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
    ignores = [ "/.direnv" ];
  };

  programs.vim = {
    enable = true;

    extraConfig = ''
      nmap <Space><Space> :update<CR>
      nmap <Space>q :q<CR>
      set hls
    '';

    settings = {
      tabstop = 8;
      shiftwidth = 8;
      expandtab = false;
      number = true;
      undofile = true;
      undodir = [ "${config.xdg.cacheHome}/vim/undodir" ];
    };

    plugins = [ pkgs.vimPlugins.vim-bracketed-paste ];
  };

  programs.vscode = {
    enable = true;
  };

  home.packages = [
    # FIXME: https://github.com/NixOS/nixpkgs/pull/347688#issuecomment-2419813563
    (lib.hiPrio (pkgs.runCommand "vscode-workaround" {} ''
      mkdir -p "$out/share/applications"
      sed -e '/StartupWMClass/d' "${config.programs.vscode.package}/share/applications/code-url-handler.desktop" > "$out/share/applications/code-url-handler.desktop"
    ''))
  ];

  services.syncthing = {
    enable = true;
  };

  home = {
    username = "dram";
    homeDirectory = "/home/dram";
    stateVersion = "21.05";
  };
}
