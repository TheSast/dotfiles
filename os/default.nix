{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./secrets.nix
    ./dm.nix
  ];

  boot = {
    plymouth = {
      enable = true;
      theme = "breeze";
    };
    consoleLogLevel = 0; # reduce console logs
    initrd.verbose = false; # reduce initrd output
    initrd.systemd.enable = true; # use initrd, apparently spawning plymouth faster
    kernelParams = [
      "quiet" # ask quiet
      "fbcon=nodefer" # do not use vendor logo
      # "splash"
      # "vga=current"
      "loglevel=3" # only produce errors and worse
      "udev.log_level=3" # same as above
      "rd.udev.log_level=3" # same as above for initrd
      "rd.systemd.show_status=false" # hide systemd messages
      "vt.global_cursor_default=0" # remove cursor blink
    ];
  };

  networking = {
    networkmanager = {
      enable = true;
      ethernet = {
        macAddress = "random";
      };
      wifi = {
        macAddress = "random";
        scanRandMacAddress = true;
      };
    };
  };

  time.timeZone = "UTC";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "C.UTF-8";
      LC_COLLATE = "C.UTF-8";
      LC_IDENTIFICATION = "C.UTF-8";
      LC_MEASUREMENT = "C.UTF-8";
      LC_MONETARY = "C.UTF-8";
      LC_NAME = "C.UTF-8";
      LC_NUMERIC = "C.UTF-8";
      LC_PAPER = "C.UTF-8";
      LC_TELEPHONE = "C.UTF-8";
      LC_TIME = "en_DK.UTF-8";
    };
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandlePowerKey = "ignore";
    HandleRebootKey = "ignore";
    HandleRebootKeyLongPress = "ignore";
    HandleSuspendKey = "ignore";
    HandleSuspendKeyLongPress = "ignore";
    HandleHibernateKey = "ignore";
    HandleHibernateKeyLongPress = "ignore";
  };

  services.gpm.enable = true;

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };
  security.rtkit.enable = true;

  services.physlock.enable = false;

  services.getty = {
    greetingLine = ''> \l'';
    helpLine = "";
  };

  hardware.graphics.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu
  ];

  security = {
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id.indexOf("org.nixos") == 0) {
            polkit.log("Caching admin authentication for single NixOS operation");
            return polkit.Result.AUTH_ADMIN_KEEP;
          }
        });
      '';
    };
    pam.services.hyprlock = {};
    sudo.enable = false;
    wrappers = {
      su.enable = false;
      sudoedit.enable = false;
      sg.enable = false;
      # fusermount.enable = false; # may break appimages?
      # fusermount3.enable = false; # may break appimages?
      pkexec3.enable = false;
      newgpr.enable = false;
      chsh.enable = config.users.mutableUsers;
    };
  };
  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPasswordFile = config.age.secrets.root-hashed-password.path;
      };
      u = {
        isNormalUser = true;
        hashedPasswordFile = config.age.secrets.u-hashed-password.path;
        extraGroups = [
          "networkmanager"
          "wheel"
          "audio"
        ];
      };
    };
  };
  services.ntp.enable = !config.services.chrony.enable;
  services.chrony = {
    enable = true;
    enableNTS = true;
  };

  services.openssh = {
    enable = true;
    startWhenNeeded = lib.mkDefault true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16 32 64 28 256";
      maxtime = "168h";
      overalljails = true;
    };
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    publish = {
      enable = true;
      workstation = true;
      addresses = true;
    };
  };

  system.tools = {
    nixos-enter.enable = false;
    nixos-option.enable = false;
    nixos-install.enable = false;
    nixos-rebuild.enable = false;
    nixos-version.enable = false;
    nixos-build-vms.enable = false;
    nixos-generate-config.enable = false;
  };
  boot.enableContainers = false;
  nixpkgs.config.allowUnfree = false;
  programs = {
    fish = {
      enable = true;
      package = let
        fishNoDesktop = pkgs.symlinkJoin {
          name = "fish-no-desktop";
          paths = [pkgs.fish];
          meta = pkgs.fish;
          postBuild = ''
            rm -f $out/share/applications/fish.desktop
          '';
        };
      in
        fishNoDesktop;
      useBabelfish = true;
    };
    nano.enable = false;
    command-not-found.enable = false;
    dconf.enable = true;
  };
  documentation.doc.enable = false;
  environment = {
    binsh = lib.getExe pkgs.dash;
    defaultPackages = [];
  };
  # list executables via `ls -1  /run/current-system/sw/bin/ | sed -E 's%.*-> .{43}-%%g' | sort`
  environment.etc."current-system-packages".text = let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;

  services.fwupd.enable = true;
  services.udisks2.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.enable = true; # find a better spot! "connectivity"?

  nix = {
    channel.enable = false;
    settings.use-registries = false;
    settings.flake-registry = "";
    nixPath = [];
  };
  nixpkgs.flake = {
    setNixPath = false;
    setFlakeRegistry = false;
  };
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    use-xdg-base-directories = true;
    trusted-users = ["@wheel"];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
