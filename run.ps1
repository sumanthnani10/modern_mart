# Reads keys from android/local.properties and runs Flutter.
# Usage: .\run.ps1 [flutter args...]
$propsPath = "android\local.properties"
$mapsKey = ""
$splashToken = ""
if (Test-Path $propsPath) {
    Get-Content $propsPath | ForEach-Object {
        if ($_ -match "^\s*GOOGLE_MAPS_API_KEY\s*=\s*(.+)$") {
            $mapsKey = $matches[1].Trim()
        }
        if ($_ -match "^\s*SPLASH_LOGO_TOKEN\s*=\s*(.+)$") {
            $splashToken = $matches[1].Trim()
        }
    }
}
$defines = @()
if ($mapsKey) { $defines += "--dart-define=GOOGLE_MAPS_API_KEY=$mapsKey" }
if ($splashToken) { $defines += "--dart-define=SPLASH_LOGO_TOKEN=$splashToken" }
& flutter run $defines $args
