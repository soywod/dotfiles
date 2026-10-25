# Two NVMe in mdadm RAID1: the ESP on one array (metadata 1.0, so the
# firmware sees a plain FAT on each disk), LUKS then btrfs on the other. A
# dead disk boots degraded without intervention; see the README for the
# replacement procedure.
{
  lib,
  # By model and serial: nvme0n1 and nvme1n1 may swap between boots. Only
  # read while formatting: a replaced disk needs no change here.
  disks ? [
    "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00BL7_S64KNX0R808211"
    "/dev/disk/by-id/nvme-SSDPEKKF512G8_NVMe_INTEL_512GB_BTHH836511WE512D"
  ],
  ...
}:

{
  disko.devices = {
    disk = lib.listToAttrs (
      lib.imap0 (i: device: {
        name = "nvme${toString i}";
        value = {
          type = "disk";
          inherit device;
          content = {
            type = "gpt";
            partitions = {
              esp = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "mdraid";
                  name = "boot";
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "mdraid";
                  name = "root";
                };
              };
            };
          };
        };
      }) disks
    );

    mdadm = {
      boot = {
        type = "mdadm";
        level = 1;
        metadata = "1.0";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };
      root = {
        type = "mdadm";
        level = 1;
        content = {
          type = "luks";
          name = "crypted";
          # Written by nixos-anywhere (--disk-encryption-keys), only read
          # while formatting.
          passwordFile = "/tmp/secret.key";
          settings.allowDiscards = true;
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes =
              let
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              in
              {
                "@root" = {
                  mountpoint = "/";
                  inherit mountOptions;
                };
                "@nix" = {
                  mountpoint = "/nix";
                  inherit mountOptions;
                };
                "@srv" = {
                  mountpoint = "/srv";
                  inherit mountOptions;
                };
              };
          };
        };
      };
    };
  };
}
