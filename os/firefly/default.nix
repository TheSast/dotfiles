{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
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
    ./dualboot.nix
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-gpu-amd
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

  networking.mdns.autoAdvertise = true;

  # powerManagement.enable = true;
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amdgpu.ppfeaturemask=0xfffd3fff"
      "split_lock_detect=off"
      # "amd_pstate=active"
      # "amd_pstate=guided"
      "pcie_aspm.policy=performance"
      # "amdgpu.runpm=0"
      # "amdgpu.aspm=0"
    ];
    initrd.kernelModules = ["amdgpu"];
    kernelModules = [
      "amdgpu"
      "hid_nintendo"
      "hid_playstation"
      "ntsync"
    ];
  };
  hardware = {
    # graphics.enable = true; # in nixos-hardware
    # nvidia.open = false;
    enableRedistributableFirmware = true; # in nixos-hardware
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
    decky-loader = {
      enable = true;
      # extraPackages = [pkgs.pnpm_10];
    };
    devices.steamdeck.enableControllerUdevRules = true;
    hardware.has.amd.gpu = true;
  };
  services.greetd.enable = lib.mkForce false;
  networking.extraHosts = ''
    0.0.0.0 overseauspider.yuanshen.com log-upload-os.hoyoverse.com log-upload-os.mihoyo.com dump.gamesafe.qq.com apm-log-upload-os.hoyoverse.com zzz-log-upload-os.hoyoverse.com log-upload.mihoyo.com devlog-upload.mihoyo.com uspider.yuanshen.com sg-public-data-api.hoyoverse.com hkrpg-log-upload-os.hoyoverse.com public-data-api.mihoyo.com prd-lender.cdp.internal.unity3d.com thind-prd-knob.data.ie.unity3d.com thind-gke-usc.prd.data.corp.unity3d.com cdp.cloud.unity3d.com remote-config-proxy-prd.uca.cloud.unity3d.com pc.crashsight.wetest.net
  '';
}
