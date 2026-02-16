# ============================================================
# RDP Desktop Tweaks - Script Principal
# ============================================================

if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Execute como Administrador." -ForegroundColor Red
    exit 1
}

$os = Get-CimInstance Win32_OperatingSystem
$version = $os.Version
$caption = $os.Caption

Write-Host "Sistema detectado: $caption ($version)" -ForegroundColor Cyan

$basePath = Split-Path -Parent $MyInvocation.MyCommand.Path

# ------------------------------------------------------------
# Pacotes comuns
# ------------------------------------------------------------
. "$basePath\common\power.ps1"
. "$basePath\common\visual.ps1"
. "$basePath\common\rdp.ps1"
. "$basePath\common\services-desktop.ps1"

# ------------------------------------------------------------
# Detecção de versão
# ------------------------------------------------------------
if ($caption -match "2012 R2") {
    Write-Host "Aplicando tweaks específicos do Windows Server 2012 R2"
    . "$basePath\win2012r2\windowsupdate.ps1"
}
elseif ($caption -match "2016") {
    Write-Host "Aplicando tweaks específicos do Windows Server 2016"
    . "$basePath\win2016\windowsupdate.ps1"
}
elseif ($caption -match "Windows 10" -and $caption -match "LTSC") {
    Write-Host "Aplicando tweaks para Windows 10 LTSC 2021"
    . "$basePath\win10-ltsc2021\windowsupdate.ps1"
    . "$basePath\win10-ltsc2021\defender.ps1"
    . "$basePath\win10-ltsc2021\services.ps1"
}

else {
    Write-Host "Versão não suportada explicitamente. Apenas tweaks comuns aplicados." -ForegroundColor Yellow
}

Write-Host "`nTuning concluído. Reboot recomendado." -ForegroundColor Green
