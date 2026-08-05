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

                passwordFile = config.age.secrets."firefly/luks-password".path;
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

            dp-windows = {
              size = "350G";
              type = "0700";
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
            size = "75G";

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
                # btrfs performance worse than ext4
                # "@home".mountpoint = "/home";
              };
            };
          };
          lv-home = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
              mountOptions = [
                "noatime"
              ];
            };
          };
        };
      };
    };
  };
}
