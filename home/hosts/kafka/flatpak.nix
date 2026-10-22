{ pkgs, ... }: {
  services.flatpak = {
    packages = (import ../../lib.nix).forceExplicitFlatpakPackageUpdate [
      {
        appId = "md.obsidian.Obsidian";
        commit = "092bb11df3c993bd41aebf29b91228e3dc47ebb918c0224cea792006f123e084";
      }
      {
        appId = "org.signal.Signal";
        commit = "580c5331b9fc19d6cce0db0050cfc9a017ce7fe094845c42f04d487051a2ca67";
      }
    ];
  };
}
