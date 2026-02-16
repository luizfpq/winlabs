Write-Host ">> Desativando serviços extras do Windows 10 LTSC"

$services = @(
    "DiagTrack",        # Telemetria
    "dmwappushservice",
    "SysMain",
    "WSearch",
    "WerSvc",
    "RetailDemo",
    "RemoteRegistry",
    "MapsBroker",
    "lfsvc",
    "TabletInputService",
    "SharedAccess",     # ICS
    "WbioSrvc"          # Biometria
)

foreach ($svc in $services) {
    $s = Get-Service -Name $svc -ErrorAction SilentlyContinue
    if ($s) {
        Stop-Service $svc -Force -ErrorAction SilentlyContinue
        Set-Service $svc -StartupType Disabled
        Write-Host " - $svc desativado"
    }
}
#ajuste visual especifico para o windos 10
Set-ItemProperty `
  "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
  -Name EnableTransparency -Value 0
