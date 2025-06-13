{ pkgs, inputs, ... }:

{
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Allow Unfree
  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    userEmail = "ryanbruno506@gmail.com";
    userName = "Ryan Bruno";
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
}
