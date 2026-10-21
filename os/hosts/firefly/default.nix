{
  config,
  modules,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../conditional/graphical.nix
    ../../conditional/preservation.nix

    modules.jovian
    modules.nixos-hardware.common-cpu-amd-pstate
    modules.nixos-hardware.common-gpu-amd
    ./audio.nix
    ./disko.nix
    ./dualboot.nix
    ./hardware.nix
    ./identity.nix
    ./network.nix
    ./preservation.nix
    ./secrets.nix
    ./state.nix
  ];

  networking.mdns.autoAdvertise = true;

  # powerManagement.enable = true;
  services.fwupd.enable = true;
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
    enableRedistributableFirmware = true; # in nixos-hardware
  };
  services.xserver.videoDrivers = [
    "amdgpu"
  ];
  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
        "steam-jupiter-unwrapped"
        "steamdeck-hw-theme"
      ];
    permittedInsecurePackages = [
      "pnpm-9.15.9"
    ];
  };
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
      user = let
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
      in
        onlyUser;
    };
    decky-loader = {
      enable = true;
      # extraPackages = [pkgs.pnpm_10];
    };
    devices.steamdeck.enableControllerUdevRules = true;
    hardware.has.amd.gpu = true;
  };
  networking.extraHosts = ''
    0.0.0.0 overseauspider.yuanshen.com log-upload-os.hoyoverse.com log-upload-os.mihoyo.com dump.gamesafe.qq.com apm-log-upload-os.hoyoverse.com zzz-log-upload-os.hoyoverse.com log-upload.mihoyo.com devlog-upload.mihoyo.com uspider.yuanshen.com sg-public-data-api.hoyoverse.com hkrpg-log-upload-os.hoyoverse.com public-data-api.mihoyo.com prd-lender.cdp.internal.unity3d.com thind-prd-knob.data.ie.unity3d.com thind-gke-usc.prd.data.corp.unity3d.com cdp.cloud.unity3d.com remote-config-proxy-prd.uca.cloud.unity3d.com pc.crashsight.wetest.net
  '';
}
