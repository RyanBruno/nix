{ pkgs, lib, config, ... }: {

  options = {
    sshfs.enable = 
      lib.mkEnableOption "enables sshfs mounts";
  };

  config = lib.mkIf config.sshfs.enable {
    environment.systemPackages = [ pkgs.rclone ];
    environment.etc."rclone-mnt.conf".text = ''
        [thorax]
        type = sftp
        host = 10.173.174.143
        user = ryan
        key_file = /home/ryan/.ssh/id_ed25519

        [ishtar]
        type = sftp
        host = 10.173.174.196
        user = ryan
        key_file = /home/ryan/.ssh/id_ed25519
    '';

    fileSystems."/mnt/thorax" = {
        device = "thorax:/";
        fsType = "rclone";
        options = [
            "nodev"
            "nofail"
            "allow_other"
            "args2env"
            "config=/etc/rclone-mnt.conf"
        ];
    };

    fileSystems."/mnt/ishtar" = {
        device = "ishtar:/";
        fsType = "rclone";
        options = [
            "nodev"
            "nofail"
            "allow_other"
            "args2env"
            "config=/etc/rclone-mnt.conf"
        ];
    };
  };
}