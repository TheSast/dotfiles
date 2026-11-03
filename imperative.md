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

NOTES: 
- `ssh-copy-id` which is used by `nixos-anywhere` relies on `/bin/sh` being `bash`  
- The age key that is needed is not literally named `key.txt`, use the appropriate age key in the right location, as defined by the `security.nix-secrets.identityPaths` configuration.
- Add `--build-on remote` if the target machine is more performant.

### Secure Boot

Enter "Secure Boot Setup Mode" before installing, depending on the firmware it will automatically be re-enabled upon reboot.

## Home Installation

### Secrets

Make sure to add the necessary age key in the right location, as defined by the `security.nix-secrets.identityPaths` configuration.

The flake has an input to a private repository, if you are reading this and you did not write this flake, make sure to override this input with your own (you'll need to provide: `secrets.recipient` list, `secrets.storage` path, `secrets.names` list, `secrets.namesAsAttrs` set).

The private flake input will require ssh to be set up correctly to use the right ssh key, therefore said configuration needs to be bootstrapped imperatively.
