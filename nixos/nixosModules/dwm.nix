{ pkgs, lib, config, ... }: {

  options = {
    dwm.enable = 
      lib.mkEnableOption "enables dwm";
  };

  config = lib.mkIf config.dwm.enable {
    environment.systemPackages = with pkgs; [
      st
      dmenu
    ];

    # Enable the DWM Window Manager.
    services.xserver.windowManager.dwm.enable = true;

    # Enable the X11 windowing system
    services.xserver = {
      enable = true;
      #windowManager.qtile.enable = true;
    };
  };
}
