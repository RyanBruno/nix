{ pkgs, inputs, ... }:

{
  home.stateVersion = "23.11"; # Please read the comment before changing.
  home.packages = with pkgs; [
    sfeed
    neofetch
  ];

  # Allow Unfree
  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings.user = {
        email = "ryanbruno506@gmail.com";
        name = "Ryan Bruno";
    };
  };
  programs.vim = {
    enable = true;
  };
  programs.firefox = {
    enable = true;
  };
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
    ];
  };

  programs.htop.enable = true;
  programs.zsh = {
    enable = true;

    # Enable command completion
    enableCompletion = true;
  };
}

