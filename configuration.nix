{ pkgs, ... }:
{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU
  nix-homebrew.autoMigrate = true;

  system.primaryUser = "kirubeltadesse";
	users.users.kirubeltadesse = {
    home = "/Users/kirubeltadesse";
    shell = "${pkgs.bash}/bin/bash";
	};
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    trackpad.Clicking = true;              # tap to click
  };
  nix-homebrew = {
    enable = true;
    user = "kirubeltadesse";
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    taps = [
      "daipeihust/tap"
    ];
    brews = [
      "delta"
      # "tmux-fingers"
      "leohenon/tap/ocv"
      "herdr"
    ];
    casks = [
      "wezterm"
      "opensuperwhisper"
      # "obs"
      # "claude-code"
    ];
  };
}
