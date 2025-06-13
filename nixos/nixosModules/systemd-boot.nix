{ pkgs, lib, config, ... }: {

  options = {
    systemd-boot.enable = 
      lib.mkEnableOption "enables systemd-boot";
  };

  config = lib.mkIf config.systemd-boot.enable {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}