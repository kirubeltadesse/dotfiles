{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = "kirubeltadesse";
  home.homeDirectory = "/Users/kirubeltadesse";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    macism
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    neovim
    lazygit
	  tmux
    nb
    zoxide
    lynx
    # the font everything renders in
    # nerd-fonts.hack
  ];

  fonts.fontconfig.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";
    LYNX_CFG = "${config.home.homeDirectory}/.config/lynx/lynx.cfg";
    LYNX_LSS = "${config.home.homeDirectory}/.config/lynx/lynx.lss";
  };
  programs.bash = {
    enable = true;
    enableCompletion = false;
    profileExtra = ''
      export BASH_SILENCE_DEPRECATION_WARNING=1
      if [ -f ~/.bashrc ]; then
        source ~/.bashrc
      fi
    '';
    initExtra = ''
      # added by the dotfile installer
      DOTFILES_DIR="$HOME/.dotfiles"

      for DOTFILE in "$DOTFILES_DIR"/system/.{env,prompt,alias,function};
      do
          [ -f "$DOTFILE" ] && . "$DOTFILE"
      done

      # enable bat for fzf
      export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
      export FZF_DEFAULT_OPTS='--preview="bat --style=numbers --color=always --line-range :500 {}" --bind alt-j:preview-down,alt-k:preview-up,alt-d:preview-page-down,alt-u:preview-page-up'
      export FZF_DEFAULT_OPS="--extended"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

      # add clear screen command
      bind -x '"\C-g": "clear"'

      export PATH=$PATH:~/.nb/
      export set_PS1
      export NB_PREVIEW_COMMAND="bat"

      [ -f ~/.fzf.bash ] && source ~/.fzf.bash
      eval "$(zoxide init --cmd cd bash)"
      [ -f ~/.bbrc ] && source ~/.bbrc

      # Lynx search engines & urlencode
      source "${dotfiles}/browser/lynx/urlencode"
      source "${dotfiles}/browser/lynx/searchEngine"
    '';
  };

  #programs.zsh = {
    #enable = true;
    #enableCompletion = true;
    #autosuggestion.enable = true;
    #syntaxHighlighting.enable = true;
    
    #sessionVariables = {
      #EDITOR = "nvim";
      #FZF_DEFAULT_COMMAND = 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .git';
    #};

    #initExtra = ''
      #eval "$(zoxide init --cmd cd zsh)"
    #'';
  #};

  # programs.starship = {
  #   enable = true;
  #   settings = {
  #     add_newline = false;
  #     format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
  #     character = {
  #       success_symbol = "[❯](purple)";
  #       error_symbol = "[❯](red)";
  #     };
  #     cmd_duration.format = "[$duration]($style) ";
  #   };
  # };

  # Edit-in-place: the real file stays in my repo, ~/runcom/config just points at it.
  home.file.".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/config/wezterm";
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/config/nvim";
  home.file.".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/vim/.vimrc";
  home.file.".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/vim/.ideavimrc";
  home.file.".vim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/vim";
  home.file.".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/.tmux.conf";

  home.file."bin/vim-ime-switch".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/system/vim-ime-switch";
  home.file."bin/switch-to-amharic".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/system/switch-to-amharic";
  home.file."bin/switch-to-english".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/system/switch-to-english";
  home.file."bin/toggle-ime".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/system/toggle-ime";

  home.file.".config/lynx/lynx.cfg".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/browser/lynx/lynx.cfg";
  home.file.".config/lynx/lynx.lss".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/browser/lynx/lynx.lss";
  # Files below were referenced in the documentation but not found in your runcom/ structure.
  # If you need them, please place them in runcom/ and update these paths.
#  home.file.".config/herdr".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/config/herdr";
#  home.file.".claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/.claude/settings.json";
#
#  home.file.".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/AGENTS.md";
#  home.file.".codex/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/AGENTS.md";
#  home.file.".config/opencode/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/AGENTS.md";
}
