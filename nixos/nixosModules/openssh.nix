
{ pkgs, lib, config, ... }: {

  options = {
    openssh.enable = 
      lib.mkEnableOption "enables openssh";
  };

  config = lib.mkIf config.openssh.enable {
    # Enable the OpenSSH daemon.
    services.openssh = {
      banner = "Welcome to Ryan's endpoint!\n";
      enable = true;
      authorizedKeysInHomedir = false;
    };
  };
}