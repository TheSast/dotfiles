{
  config,
  lib,
  pkgs,
  ...
}: let
  linux_7_1_5 = pkgs.linuxKernel.kernels.linux_7_1.override {
    argsOverride = rec {
      version = "7.1.5";
      modDirVersion = version;

      src = pkgs.fetchurl {
        url = "https://www.kernel.org/pub/linux/kernel/v7.x/linux-${version}.tar.xz";
        hash = "sha256-IqAZazy83zTcJ7d1YfTQQFhf00R+3JqzUxoax54wQec=";
      };
    };
  };

  definedUsers = builtins.attrNames (
    lib.filterAttrs (_: user: user.isNormalUser or false) config.users.users
  );

  onlyUser =
    if config.users.mutableUsers
    then
      throw ''
        jovian.steam.user cannot be inferred when users.mutableUsers = true.
        Please set jovian.steam.user explicitly.
      ''
    else if builtins.length definedUsers == 1
    then builtins.head definedUsers
    else
      throw ''
        Expected exactly one user in users.users, found ${toString (builtins.length definedUsers)}.
        Please either:
          - define exactly one user, or
          - set jovian.steam.user explicitly.
      '';
in {
  imports = [
    ./hardware.nix
    ./disko.nix
    ../preservation.nix
    ./preservation.nix
  ];

  # system identity
  services.openssh = {
    generateHostKeys = false;
    hostKeys = [
      {path = config.age.secrets."kafka/sshd/ssh_host_ed25519_key".path;}
      {path = config.age.secrets."kafka/sshd/ssh_host_rsa_key".path;}
    ];
  };
  networking.hostName = "firefly";
  system.stateVersion = "26.05";

  # other

  boot = {
    kernelPackages = pkgs.linuxPackagesFor linux_7_1_5;
    kernelParams = [
      "amdgpu.ppfeaturemask=0xfffd3fff"
      "split_lock_detect=off"
      "amd_pstate=active"
    ];
    initrd.kernelModules = ["amdgpu"];
    kernelModules = [
      "amdgpu"
      "hid_nintendo"
      "hid_playstation"
    ];
  };
  hardware = {
    graphics.enable = true;
    # nvidia.open = false;
  };
  services.xserver.videoDrivers = [
    # "nvidia"
    "amdgpu"
  ];
  services.pipewire.pulse.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # "nvidia-kernel-modules"
      # "nvidia-settings"
      # "nvidia-x11"
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "steam-jupiter-unwrapped"
      "steamdeck-hw-theme"
    ];

  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-9.15.9"
  ];
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      extest.enable = true;
    };
    gamemode.enable = true;
    # gamescope = {
    #   capSysNice = true;
    #   enableWsi = true;
    # };
  };
  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      desktopSession = "niri";
      user = onlyUser;
    };
    decky-loader.enable = true;
    devices.steamdeck.enableControllerUdevRules = true;
    hardware.has.amd.gpu = true;
  };
  services.greetd.enable = lib.mkForce false;
}
