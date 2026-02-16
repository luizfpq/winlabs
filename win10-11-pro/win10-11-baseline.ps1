# ==========================================================
# Windows 10/11 Home/Pro - Baseline Homelab (Modular)
# ==========================================================

Write-Host "`n🔧 Aplicando Baseline Windows 10/11..." -ForegroundColor Cyan

$os = Get-CimInstance Win32_OperatingSystem
$build = [int](Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuildNumber

function Set-Policy {
    param(
        [string]$Path,
        [string]$Name,
        [int]$Value
    )

    if (!(Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }

    New-ItemProperty -Path $Path -Name $Name -PropertyType DWord -Value $Value -Force | Out-Null
    Write-Host "✔ $Name = $Value"
}

# ==========================================================
# TELEMETRIA
# ==========================================================

$DataCollection = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
Set-Policy $DataCollection "AllowTelemetry" 1
Set-Policy $DataCollection "DoNotShowFeedbackNotifications" 1

# ==========================================================
# CONSUMER / BLOAT
# ==========================================================

$CloudContent = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
Set-Policy $CloudContent "DisableWindowsConsumerFeatures" 1
Set-Policy $CloudContent "DisableSoftLanding" 1

# ==========================================================
# APP COMPAT
# ==========================================================

$AppCompat = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"
Set-Policy $AppCompat "AITEnable" 0
Set-Policy $AppCompat "DisableInventoryCollector" 1

# ==========================================================
# LOCALIZAÇÃO
# ==========================================================

$Location = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors"
Set-Policy $Location "DisableWindowsLocationProvider" 1

$FindDevice = "HKLM:\SOFTWARE\Policies\Microsoft\FindMyDevice"
Set-Policy $FindDevice "AllowFindMyDevice" 0

# ==========================================================
# STORE
# ==========================================================

$Store = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
Set-Policy $Store "AutoDownload" 2

# ==========================================================
# SEARCH
# ==========================================================

$Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
Set-Policy $Search "DisableWebSearch" 1
Set-Policy $Search "ConnectedSearchUseWeb" 0
Set-Policy $Search "AllowCloudSearch" 0

# ==========================================================
# WINDOWS 11 ESPECÍFICO (Build >= 22000)
# ==========================================================

if ($build -ge 22000) {
    Write-Host "Windows 11 detectado - aplicando restrições extras"

    $WindowsAI = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI"
    Set-Policy $WindowsAI "DisableAgenticSearch" 1
    Set-Policy $WindowsAI "DisableClickToDo" 1

    # Desabilitar Widgets
    $Dsh = "HKLM:\SOFTWARE\Policies\Microsoft\Dsh"
    Set-Policy $Dsh "AllowNewsAndInterests" 0
}

# ==========================================================
# SERVIÇOS TELEMETRIA
# ==========================================================

$services = @("DiagTrack","dmwappushservice")

foreach ($svc in $services) {
    $s = Get-Service $svc -ErrorAction SilentlyContinue
    if ($s) {
        Stop-Service $svc -Force -ErrorAction SilentlyContinue
        Set-Service $svc -StartupType Disabled
        Write-Host "✔ Serviço $svc desativado"
    }
}

Write-Host "`n✅ Baseline aplicada."
