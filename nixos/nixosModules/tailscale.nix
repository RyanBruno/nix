{ pkgs, lib, config, ... }: {

  options = {
    tailscale.enable = 
      lib.mkEnableOption "enables nvidia drivers";
  };

  config = lib.mkIf config.tailscale.enable {
    services.tailscale = {
      enable = true;
      #useRoutingFeatures = "server";
    };
  };
}