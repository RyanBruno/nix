# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
{

  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "ishtar";

  # Ryan's Modules
  nixos.enable = true;
  impermanence.enable = true;
  nvidia.enable = true;
  home-manager.enable = true;
  tailscale.enable = true;
  xrdp.enable = true;
  postgres.enable = true;

  environment.systemPackages = with pkgs; [
    obsidian
    git
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Disable Auto-Suspend
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Required to set zsh as user shell
  programs.zsh.enable = true;
  users.users.ryan = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
}
