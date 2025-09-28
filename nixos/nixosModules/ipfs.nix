{ pkgs, lib, config, ... }: {

  options = {
    ipfs.enable = 
      lib.mkEnableOption "enables ipfs's kubo";
  };

  config = lib.mkIf config.ipfs.enable {
    services.kubo = {
      enable = true;
      settings.Addresses.API = [
        "/ip4/127.0.0.1/tcp/5001"
      ];
      settings = {
        "API" = {
          "HTTPHeaders" = {
            "Access-Control-Allow-Origin" = [
              "http://localhost:3000"
              "http://127.0.0.1:5001"
              "https://webui.ipfs.io"
            ];
            "Access-Control-Allow-Methods" = [
              "PUT"
              "POST"
            ];
          };
        };
      };
    };
  };
}
