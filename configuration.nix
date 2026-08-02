{ pkgs, ... }:
{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  environment.shells = [ pkgs.bashInteractive ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU
  nix-homebrew.autoMigrate = true;

  system.primaryUser = "kirubeltadesse";
	users.users.kirubeltadesse = {
    home = "/Users/kirubeltadesse";
	    shell = "${pkgs.bashInteractive}/bin/bash";
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
    universalaccess.reduceMotion = true;
    CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # Enable Mission Control shortcuts for switching directly to Desktop 1-9.
          "118" = {
            enabled = true;
            value = {
              parameters = [ 65535 18 262144 ];
              type = "standard";
            };
          };
          "119" = {
            enabled = true;
            value = {
              parameters = [ 65535 19 262144 ];
              type = "standard";
            };
          };
          "120" = {
            enabled = true;
            value = {
              parameters = [ 65535 20 262144 ];
              type = "standard";
            };
          };
          "121" = {
            enabled = true;
            value = {
              parameters = [ 65535 21 262144 ];
              type = "standard";
            };
          };
          "122" = {
            enabled = true;
            value = {
              parameters = [ 65535 23 262144 ];
              type = "standard";
            };
          };
          "123" = {
            enabled = true;
            value = {
              parameters = [ 65535 22 262144 ];
              type = "standard";
            };
          };
          "124" = {
            enabled = true;
            value = {
              parameters = [ 65535 26 262144 ];
              type = "standard";
            };
          };
          "125" = {
            enabled = true;
            value = {
              parameters = [ 65535 28 262144 ];
              type = "standard";
            };
          };
          "126" = {
            enabled = true;
            value = {
              parameters = [ 65535 25 262144 ];
              type = "standard";
            };
          };
        };
      };
    };
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
