Write-Host ">> Desativando serviços desnecessários para RDP Desktop"

$services = @(
    "WSearch",        # Windows Search
    "SysMain",        # Superfetch
    "DiagTrack",      # Telemetria
    "MapsBroker",     # Mapas offline
    "lfsvc",          # Geolocalização
    "Fax",
    "XblGameSave",
    "XboxNetApiSvc",
    "WMPNetworkSvc",
    "WerSvc",         # Error Reporting
    "RetailDemo",
    "RemoteRegistry"
)

foreach ($svc in $services) {
    $s = Get-Service -Name $svc -ErrorAction SilentlyContinue
    if ($s) {
        Stop-Service $svc -Force -ErrorAction SilentlyContinue
        Set-Service $svc -StartupType Disabled
        Write-Host " - $svc desativado"
    }
}
