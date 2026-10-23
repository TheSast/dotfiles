reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System /f /v DisableLockWorkstation
rundll32.exe user32.dll,LockWorkStation
Start-Sleep -Seconds 3
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System /f /v DisableLockWorkstation /t REG_DWORD /d 1
