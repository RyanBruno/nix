{ pkgs, lib, config, ... }: {

  options = {
    impermanence.enable = 
      lib.mkEnableOption "enables impermanence";
  };

  config = lib.mkIf config.impermanence.enable {
    # Impermanent Wipe devie
    boot.initrd.postResumeCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/mapper/crypted /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
    
    fileSystems."/persist".neededForBoot = true;
    environment.persistence."/persist/system" = {
      hideMounts = true;
      directories = [
        # Home
        "/home/ryan/src"
        "/home/ryan/.ssh"

        # Docker
        "/var/lib/docker"

        # Logs
        "/var/log"
        "/var/lib/systemd/coredump"

        # Nixos (User maps, group maps...)
        "/var/lib/nixos"

        # Keys
        "/etc/passwd.d"
        "/var/lib/tailscale"
        "/etc/ssh/host_keys"
      ];
      files = [
        "/etc/machine-id"
        #{ file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
      ];
    };
  };
}
