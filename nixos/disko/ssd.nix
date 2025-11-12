{
  disko.devices = {
    disk = {
      ssd = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "ssd";
                settings.allowDiscards = true;
                #passwordFile = "/tmp/secret.key";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/ssd";
                };
              };
            };
          };
        };
      };
    };
  };
}