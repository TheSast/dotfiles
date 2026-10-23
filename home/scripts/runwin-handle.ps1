$request = 'X:\runwin-request.txt'

if (-not (Test-Path $request)) { exit }

$app = (Get-Content -Raw $request).Trim()
Remove-Item $request -Force

switch ($app) {
    'destiny2' {
        Start-Process 'steam://rungameid/APP_ID'
    }
    default {
        Write-Error "Unknown app request: $app"
        exit 1
    }
}
