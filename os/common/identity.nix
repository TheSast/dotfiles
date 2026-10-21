{
  flake,
  config,
  lib,
  ...
}: {
  boot.initrd.systemd.suppressedUnits = ["systemd-machine-id-commit.service"];
  environment.etc.machine-id.text =
    lib.strings.substring 0 32 (lib.hashString "sha256" config.networking.hostName) + "\n";
  system.configurationRevision = flake.shortRev or flake.dirtyShortRev;
  networking.hostId = lib.strings.substring 0 8 (lib.hashString "sha256" config.networking.hostName);
}
