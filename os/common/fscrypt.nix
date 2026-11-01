{pkgs, ...}: {
  # https://github.com/google/fscrypt/issues/405
  systemd.services.greetd.serviceConfig.LimitMEMLOCK = "infinity";
  security.pam.enableFscrypt = true;
  systemd.services."fscrypt-preservation-setup" = {
    description = "set up fscrypt for home encryption by users";
    wantedBy = ["multi-user.target"];
    after = [
      "dur.mount"
      "home.mount"
    ];
    wants = [
      "dur.mount"
      "home.mount"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = with pkgs; [
      util-linux
      fscrypt-experimental
    ];
    script = ''
      set -euo pipefail

      if [ -s /etc/fscrypt.conf ] && [ -n "$(find /.fscrypt -mindepth 1 -print -quit)" ] && [ -e /dur ]; then
        echo "fscrypt is already set up"
        exit 0
      fi

      mountpoint -q /etc/fscrypt.conf && umount /etc/fscrypt.conf
      mountpoint -q /.fscrypt && umount /.fscrypt
      rm -f /etc/fscrypt.conf
      for dir in /.fscrypt /dur/.fscrypt; do
        if [ -d "$dir" ]; then
          rmdir -- "$dir"
        fi
      done
      fscrypt setup --all-users
      fscrypt setup /home --all-users
      cp /etc/fscrypt.conf /dur/etc/fscrypt.conf
      cp -a /.fscrypt /dur/.fscrypt
      mount --bind /dur/etc/fscrypt.conf /etc/fscrypt.conf
      mount --bind /dur/.fscrypt /.fscrypt

      echo "fscrypt setup complete"
    '';
  };
}
