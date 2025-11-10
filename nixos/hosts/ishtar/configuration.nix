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
  postgres.enable = false;
  openssh.enable = true;
  gdm.enable = false;
  systemd-boot.enable = true;
  elk.enable = false;
  home-assistant.enable = true;
  ipfs.enable = false;
  homepage.enable = true;
  dwm.enable = true;

  # Disable Auto-Suspend
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  qemu = {
    enable = false;
    isoPath = "/var/lib/qemu/latest-nixos-minimal-x86_64-linux.iso";
    autostart = true;
    enableVNC = true;
    diskPath = "/var/lib/qemu/disk.qcow2";
    # optional tweaks:
    # cpu = 6;
    # memory = "12G";
  };

  # Required to set zsh as user shell
  programs.zsh.enable = true;
  users.users.ryan = {
    isNormalUser = true;
    hashedPasswordFile = "/persist/system/etc/passwd.d/ryan.hash";
    extraGroups = [
      "ipfs"
      "wheel"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN2MAboR5VJ4U3rrRz9UjQq4I8YDUd6doqbBLg2LGu5S ryanbruno506@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGAFJPfIffDacoJ2OG5aaF5lR/OfTxc0gHvx6LJLAQj ryanbruno506@gmail.com"
    ];
  };

  environment.systemPackages = [
    pkgs.angle-grinder
  ];
}
