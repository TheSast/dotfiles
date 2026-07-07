{config, ...}: {
  # prefix meanings:
  # d-  disk
  # dp- disk partition
  # c-  crypt
  # vg- volume group
  # lv- logical volume
  # @   subvolume
  disko.devices = {
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=25%"
          "mode=755"
        ];
      };
    };

    disk = {
      d-nvme = {
        type = "disk";
        device = "/dev/nvme0n1";

        content = {
          type = "gpt";

          partitions = {
            dp-boot = {
              priority = 1;
              size = "1G";
              type = "EF00";

              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "umask=0077"
                ];
              };
            };

            dp-luks-container = {
              size = "100%";

              content = {
                type = "luks";
                name = "c-storage";

                passwordFile = config.age.secrets."kafka/luks-password".path;
                enrollFinalTPM2PostInstall = true;
                extraFinalTPM2EnrollArgs = ["--tpm2-pcrs=0+7"];

                settings = {
                  allowDiscards = true;
                };

                content = {
                  type = "lvm_pv";
                  vg = "vg-system";
                };
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      vg-system = {
        type = "lvm_vg";
        lvs = {
          lv-system = {
            size = "250G";

            content = {
              type = "btrfs";

              extraArgs = [
                "-f"
                # add "-L" "lv-system" ?
              ];

              mountOptions = [
                "compress=zstd"
                "noatime"
              ];

              subvolumes = {
                "@nix".mountpoint = "/nix";
                "@dur".mountpoint = "/dur";
                # btrfs does not support fscrypt encryption, when added, move `/home` from lvm logical volume to btrfs subvolume
                # "@home".mountpoint = "/home";
              };
            };
          };
          lv-home = {
            size = "500G";
            content = {
              type = "filesystem";
              format = "ext4";
              extraArgs = [
                "-O"
                "encrypt"
              ];
              mountpoint = "/home";
              mountOptions = [
                "noatime"
              ];
            };
          };
          lv-swap = {
            size = "32G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
        };
      };
    };
  };
}
