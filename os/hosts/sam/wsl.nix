{
  config,
  lib,
  ...
}: let
  cfg = config.wsl;
in {
  options.wsl = {
    openFirewall = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Open Hyper-V firewall to allow incoming connections.";
    };

    networkingMode = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "None"
          "Nat"
          "Bridged"
          "Mirrored"
          "Consomme"
        ]
      );
      default = null;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.openFirewall {
      winpkgs.activation.installOpenSSHServer.command =
        #powershell
        ''
          Set-NetFirewallHyperVVMSetting -Name '{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}' -DefaultInboundAction Allow
        '';
    })
    (lib.mkIf (!cfg.openFirewall) {
      winpkgs.activation.installOpenSSHServer.command =
        #powershell
        ''
          # TODO: implement
        '';
    })
    (lib.mkIf (cfg.networkingMode != null) {
      winpkgs.activation.removeOpenSSHServer.command = let
        mode = cfg.networkingMode;
      in
        # powershell
        ''
          $config = Join-Path $HOME ".wslconfig"

          if (Test-Path $config) {
              Copy-Item $config "$config.bak" -Force
              $text = Get-Content $config -Raw
          } else {
              $text = ""
          }

          if ($text -match '(?im)^\s*\[wsl2\]\s*$') {
              if ($text -match '(?im)^\s*networkingMode\s*=.*$') {
                  $text = [regex]::Replace(
                      $text,
                      '(?im)^\s*networkingMode\s*=.*$',
                      'networkingMode=${mode}',
                      1
                  )
              } else {
                  $text = [regex]::Replace(
                      $text,
                      '(?im)^(\s*\[wsl2\]\s*\r?\n)',
                      "`$1networkingMode=${mode}`r`n",
                      1
                  )
              }
          } else {
              $text = $text.TrimEnd() + "`r`n`r`n[wsl2]`r`nnetworkingMode=mirrored`r`n"
          }

          Set-Content -Path $config -Value $text -Encoding ascii
          # wsl.exe --shutdown

          Write-Host "Enabled selected networking. Start WSL again to use it."
        '';
    })
  ];
}
