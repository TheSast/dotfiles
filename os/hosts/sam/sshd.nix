{
  config,
  lib,
  ...
}:
let
  cfg = config.services.opensshServer;
in
{
  options.services.opensshServer = {
    enable = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Install and enable OpenSSH Server; false removes it; null leaves it alone.";
    };

    startupType = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "Automatic"
          "Disabled"
          "Manual"
        ]
      );
      default = null;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable == true) {
      winpkgs.activation.installOpenSSHServer.command =
        # powershell
        ''
          $capabilityName = 'OpenSSH.Server~~~~0.0.1.0'
          $capability = Get-WindowsCapability -Online -Name $capabilityName
          if ($capability.State -ne 'Installed') {
          # TODO: need post-quantum option
            Add-WindowsCapability -Online -Name $capabilityName | Out-Null
            Start-Service -Name sshd
            Set-Service -Name sshd -StartupType Automatic
            ${lib.optionalString (!cfg.enable)
              # TODO: remove the OpenSSH-Server-In-TCP rule if it remains.
              # powershell
              ''
                    $service = Get-Service -Name sshd -ErrorAction SilentlyContinue
                    if ($service) {
                      if ($service.Status -ne 'Stopped') {
                        Stop-Service -Name sshd -Force
                      }
                    }

                    $capability = Get-WindowsCapability -Online -Name 'OpenSSH.Server~~~~0.0.1.0'
                    if ($capability.State -eq 'Installed') {
                      Remove-WindowsCapability -Online -Name 'OpenSSH.Server~~~~0.0.1.0' | Out-Null
                    }
                ${lib.optionalString (cfg.startupType != null && cfg.startupType != "Disabled")
                  # powershell
                  ''
                    Set-Service -Name sshd -StartupType ${cfg.startupType}
                    Start-Service -Name sshd
                  ''
                }
                ${lib.optionalString (cfg.startupType == "Disabled")
                  # powershell
                  ''
                    Set-Service -Name sshd -StartupType ${cfg.startupType}
                    Stop-Service -Name sshd
                  ''
                }
              ''
            }
          }
        '';
    })
    # (lib.mkIf (cfg.enable == false) {})
  ];
}
