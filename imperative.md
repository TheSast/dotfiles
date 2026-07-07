# Imperative steps that do not have declarative solutions

## OS Installation

For installation of systems that support `nixos-anywhere` and disko (e.g. [./os/kafka](./os/kafka)) you need to set up a minimal live ISO environment on the target machine with the correct secure boot settings.
Then you connect it to the same network as your working machine:
```fish
nmcli device wifi connect <SSID> password <PASSWORD>
```
Then you must give the `root` user a password:
```fish
sudo passwd
```
Then you can proceed with the installation:
```fish
set TEMP_DIR (mktemp -d); mkdir -p $TEMP_DIR/dur; cp ~/.config/age/key.txt $TEMP_DIR/dur/nixos_age_key; chmod 600 $TEMP_DIR/dur/nixos_age_key
nix run github:nix-community/nixos-anywhere -- --extra-files $TEMP_DIR -f .#<your-chosen-nixos-config> --target-host root@nixos
```
NOTE: `ssh-copy-id` which is used by `nixos-anywhere` relies on `/bin/sh` being `bash`  
Add `--build-on remote` if the target machine is more performant.

### Secure Boot

Enter "Secure Boot Setup Mode" before installing, depending on the firmware it will automatically be re-enabled upon reboot.

## Home Installation

For the initial installation of dotfiles, you will need to set $XDG_CONFIG_HOME to the value set for `xdg.configHome` for agenix secrets to be properly placed as files.
