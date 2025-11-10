{ pkgs, lib, config, ... }:

let
  cfg = config.qemu;
in {
  options.qemu = {
    enable = lib.mkEnableOption "Enable a simple QEMU VM";

    name = lib.mkOption {
      type = lib.types.str;
      default = "qemu-01";
      description = "VM name/ID (also the systemd service name).";
    };

    isoPath = lib.mkOption {
      type = lib.types.path;
      description = "Path to the NixOS installer ISO.";
      example = "/var/lib/qemu/iso/nixos-minimal-x86_64-linux.iso";
    };

    diskPath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/qemu/disk.qcow2";
      description = "Path to the qcow2 disk image.";
    };

    diskSize = lib.mkOption {
      type = lib.types.str;
      default = "40G";
      description = "Size for qcow2 if created at first boot.";
    };

    cpu = lib.mkOption {
      type = lib.types.int;
      default = 4;
      description = "vCPU count.";
    };

    memory = lib.mkOption {
      type = lib.types.str;
      default = "8G";
      description = "RAM for the VM (e.g., 4096M, 8G).";
    };

    macAddress = lib.mkOption {
      type = lib.types.str;
      default = "52:54:00:12:34:56";
      description = "Static MAC address.";
    };

    enableVNC = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Expose VNC on 127.0.0.1:5901.";
    };

    extraQemuArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra args appended to qemu-system-x86_64.";
    };

    autostart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Start VM at boot and restart on failure.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.name} = {};

    systemd.tmpfiles.rules = [
      "d /var/lib/${cfg.name} 0750 root ${cfg.name} - -"
      "d /var/lib/${cfg.name}/iso 0750 root ${cfg.name} - -"
    ];

    systemd.services."${cfg.name}" = {
      description = "QEMU ${cfg.name}";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = lib.optionals cfg.autostart [ "multi-user.target" ];

      # Create disk on first start & sanity-check ISO
      preStart = ''
        if [ ! -e "${cfg.diskPath}" ]; then
          ${pkgs.qemu_kvm}/bin/qemu-img create -f qcow2 "${cfg.diskPath}" ${cfg.diskSize}
        fi
        if [ ! -r "${cfg.isoPath}" ]; then
          echo "ISO not found at ${cfg.isoPath}" >&2
          exit 1
        fi
      '';

      serviceConfig =
        {
          Type = "simple";
          DynamicUser = true;
          Group = "${cfg.name}";
          WorkingDirectory = "/var/lib/${cfg.name}";
          PrivateDevices = true;
          DeviceAllow = [ "char-kvm rw" ];
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          NoNewPrivileges = true;
          SupplementaryGroups = [ "kvm" ];
        }
        // (if cfg.autostart then { Restart = "always"; RestartSec = "3s"; } else { });

      script = let
        qemu = pkgs.qemu_kvm;
        netArgs = [
          "-netdev" "user,id=net0" # NAT (slirp)
          "-device" "virtio-net-pci,netdev=net0,mac=${cfg.macAddress}"
        ];
        vncArgs = lib.optionals cfg.enableVNC [ "-vnc" "127.0.0.1:1" ];
      in
        lib.concatStringsSep " " ([
          "${qemu}/bin/qemu-system-x86_64"
          "-name" "${cfg.name}"
          "-enable-kvm"
          "-cpu" "host"
          "-smp" (toString cfg.cpu)
          "-m" cfg.memory
          "-drive" "if=virtio,format=qcow2,file=${cfg.diskPath},cache=none,discard=unmap"
          "-cdrom" "${cfg.isoPath}"
          "-boot" "order=d,menu=on"
          "-display" "none"
        ] ++ vncArgs ++ netArgs ++ cfg.extraQemuArgs);
    };

    # Limit VNC exposure to loopback
    networking.firewall.interfaces = lib.mkIf cfg.enableVNC {
      lo.allowedTCPPorts = [ 5901 ];
    };
  };
}
