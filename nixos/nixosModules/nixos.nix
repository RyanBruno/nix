{ pkgs, lib, config, ... }: {

  options = {
    nixos.enable = 
      lib.mkEnableOption "enables Ryan's default nixos configs";
  };

  config = lib.mkIf config.nixos.enable {
    system.stateVersion = "24.05"; # Did you read the comment?
    
    # Allow Unfree
    nixpkgs.config.allowUnfree = true;

    # Nix Configs
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    
    # Set your time zone.
    time.timeZone = "America/New_York";
    
    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    
    # Configure keymap in X11
    services.xserver.xkb.layout = "us";

    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 1d";
    };
  };
}
