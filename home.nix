{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = "kirubeltadesse";
  home.homeDirectory = "/Users/kirubeltadesse";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
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
  home.sessionVariables.EDITOR = "nvim";
  programs.bash = {
    enable = true;
    initExtra = ''
      bindkey '^f' autosuggest-accept
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
  # Files below were referenced in the documentation but not found in your runcom/ structure.
  # If you need them, please place them in runcom/ and update these paths.
#  home.file.".config/herdr".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/config/herdr";
#  home.file.".claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/.claude/settings.json";
#
#  home.file.".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/AGENTS.md";
#  home.file.".codex/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/AGENTS.md";
#  home.file.".config/opencode/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/runcom/AGENTS.md";
}
