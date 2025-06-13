{ pkgs, lib, config, ... }: {

  options = {
    gdm.enable = 
      lib.mkEnableOption "enables gdm";
  };

  config = lib.mkIf config.gdm.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
  };
}