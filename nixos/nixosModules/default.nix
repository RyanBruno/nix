
{ pkgs, lib, ... }: {
  imports = [
    ./elk.nix
    ./impermanence.nix
    ./nixos.nix
    ./nvidia.nix
    ./home-manager.nix
    ./tailscale.nix
    ./xrdp.nix
    ./postgres.nix
    ./openssh.nix
    ./gdm.nix
    ./systemd-boot.nix
    ./homeassistant.nix
    ./ipfs.nix
    ./homepage.nix
    ./qemu.nix
    ./dwm.nix
  ];
}
