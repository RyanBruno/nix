{ pkgs, inputs, ... }:

{
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Allow Unfree
  nixpkgs.config.allowUnfree = true;

  programs.vim = {
    enable = true;
  };
  programs.firefox = {
    enable = true;
  };
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
    ];
  };
}
