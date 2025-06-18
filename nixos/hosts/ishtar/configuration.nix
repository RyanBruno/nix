# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
{

  imports = [
    ./hardware-configuration.nix
  ];
  programs.nix-ld.enable = true;

  networking.hostName = "ishtar";

  # Ryan's Modules
  nixos.enable = true;
  impermanence.enable = true;
  nvidia.enable = true;
  home-manager.enable = true;
  tailscale.enable = true;
  xrdp.enable = false;
  postgres.enable = true;
  openssh.enable = true;
  gdm.enable = true;
  systemd-boot.enable = true;

  # Required to set zsh as user shell
  programs.zsh.enable = true;
  users.users.ryan = {
    isNormalUser = true;
    hashedPasswordFile = "/etc/passwd.d/ryan.hash";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN2MAboR5VJ4U3rrRz9UjQq4I8YDUd6doqbBLg2LGu5S ryanbruno506@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGAFJPfIffDacoJ2OG5aaF5lR/OfTxc0gHvx6LJLAQj ryanbruno506@gmail.com"
    ];
  };
}
