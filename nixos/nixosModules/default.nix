
{ pkgs, lib, ... }: {
  imports = [
    ./impermanence.nix
    ./nixos.nix
    ./nvidia.nix
    ./home-manager.nix
    ./tailscale.nix
    ./xrdp.nix
    ./postgres.nix
  ];
}
