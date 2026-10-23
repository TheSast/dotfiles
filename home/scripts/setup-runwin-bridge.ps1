$label  = 'RUNWIN'
$letter = 'X:'
$folder = 'X:\runwin'

$matches = @(
    Get-CimInstance -ClassName Win32_Volume |
    Where-Object {
        $_.Label -eq $label -and
        $_.FileSystem -in @('FAT', 'FAT32', 'exFAT')
    }
)

if ($matches.Count -ne 1) {
    throw "Expected exactly one FAT/exFAT volume labeled '$label'; found $($matches.Count)."
}

$volume = $matches[0]

if ($volume.DriveLetter -eq $letter -and
    (Test-Path -LiteralPath $folder -PathType Container)) {
    Write-Output 'this is already correctly set up'
    exit 0
}

if ($volume.DriveLetter -and $volume.DriveLetter -ne $letter) {
    throw "The matching volume already has drive letter $($volume.DriveLetter). Change it to $letter manually, or update this script."
}

$xInUse = Get-CimInstance -ClassName Win32_Volume |
    Where-Object { $_.DriveLetter -eq $letter }

if ($xInUse) {
    throw "$letter is already assigned to another volume."
}

if (-not $volume.DriveLetter) {
    $volume | Set-CimInstance -Property @{ DriveLetter = $letter } | Out-Null
    Start-Sleep -Seconds 1
}

if (-not (Test-Path -LiteralPath 'X:\')) {
    throw "The volume was not available at $letter."
}

if (-not (Test-Path -LiteralPath $folder -PathType Container)) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
}

Write-Output "Setup complete: volume '$label' is available at $folder"
