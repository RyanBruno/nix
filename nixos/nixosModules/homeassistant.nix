{ pkgs, lib, config, ... }: {

  options = {
    home-assistant.enable = 
      lib.mkEnableOption "enables home-assistant";
  };

  config = lib.mkIf config.home-assistant.enable {
    virtualisation.oci-containers = {
      backend = "docker";
      containers.homeassistant = {
        volumes = [ "home-assistant:/config" ];
        environment.TZ = "America/New_York";
        # Note: The image will not be updated on rebuilds, unless the version label changes
        image = "ghcr.io/home-assistant/home-assistant:stable";
        extraOptions = [ 
          # Use the host network namespace for all sockets
          "--network=host"
          # Pass devices into the container, so Home Assistant can discover and make use of them
          "--device=/dev/ttyUSB0:/dev/ttyUSB0"
        ];
      };
    };
  };
}