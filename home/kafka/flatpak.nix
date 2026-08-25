{
  services.flatpak.packages = (import ../lib.nix).forceExplicitFlatpakPackageUpdate [
    {
      appId = "md.obsidian.Obsidian";
      commit = "092bb11df3c993bd41aebf29b91228e3dc47ebb918c0224cea792006f123e084";
    }
  ];
}
