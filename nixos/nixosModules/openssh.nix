
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
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
      hostKeys = [
        {
          bits = 4096;
          path = "/etc/ssh/host_keys/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "/etc/ssh/host_keys/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}