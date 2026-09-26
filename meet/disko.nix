# Declarative disk layout used by nixos-anywhere to partition + format the VPS.
#
# CONFIRM two things on the VPS before you run anything:
#   ssh root@<vps> lsblk                                   # the disk device
#   ssh root@<vps> '[ -d /sys/firmware/efi ] && echo UEFI || echo BIOS'
#
# This template is BIOS/GRUB (a GPT disk with a 1 MiB BIOS-boot partition),
# which is what most cheap KVM VPS use. For a UEFI VPS, swap the `boot`
# partition for the commented `esp` block and switch the bootloader in
# configuration.nix.
{ ... }:
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        # BIOS/GRUB on GPT needs this tiny BIOS-boot partition.
        boot = {
          size = "1M";
          type = "EF02";
        };

        # UEFI instead? Delete `boot` above and use this ESP:
        # esp = {
        #   size = "512M";
        #   type = "EF00";
        #   content = {
        #     type = "filesystem";
        #     format = "vfat";
        #     mountpoint = "/boot";
        #     mountOptions = [ "umask=0077" ];
        #   };
        # };

        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
