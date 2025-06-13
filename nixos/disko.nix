{
  device ? throw "Set this to your disk device, e.g. /dev/sda",
  ...
}: {
  disko.devices = {
    disk = {
      main = {
        inherit device;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "4G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                # disable settings.keyFile if you want to use interactive password entry
                #passwordFile = "/tmp/secret.key"; # Interactive
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                    };

                    "/persist" = {
                      mountOptions = ["subvol=persist" "noatime"];
                      mountpoint = "/persist";
                    };

                    "/nix" = {
                      mountOptions = ["subvol=nix" "noatime"];
                      mountpoint = "/nix";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
