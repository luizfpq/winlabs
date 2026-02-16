# ============================================================
# Otimização Windows Server 2012 R2
# Uso: Desktop RDP leve (Home Lab)
# Execute como Administrador
# ============================================================

Write-Host "Iniciando otimizações para RDP..." -ForegroundColor Cyan

# ------------------------------------------------------------
# 1. Plano de Energia: Alto Desempenho
# ------------------------------------------------------------
Write-Host ">> Ativando plano de energia Alto Desempenho"
powercfg -setactive SCHEME_MIN

# ------------------------------------------------------------
# 2. Desativar Windows Search
# ------------------------------------------------------------
Write-Host ">> Desativando Windows Search"
Stop-Service WSearch -Force -ErrorAction SilentlyContinue
Set-Service WSearch -StartupType Disabled

# ------------------------------------------------------------
# 3. Desativar Superfetch (SysMain)
# ------------------------------------------------------------
Write-Host ">> Desativando Superfetch (SysMain)"
Stop-Service SysMain -Force -ErrorAction SilentlyContinue
Set-Service SysMain -StartupType Disabled

# ------------------------------------------------------------
# 4. Desativar Windows Update (LAB ISOLADO)
# ------------------------------------------------------------
Write-Host ">> Desativando Windows Update (uso apenas em lab)"
Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
Set-Service wuauserv -StartupType Disabled

# ------------------------------------------------------------
# 5. Ajustar efeitos visuais para MELHOR DESEMPENHO
# ------------------------------------------------------------
Write-Host ">> Ajustando efeitos visuais para melhor desempenho"

$visualEffects = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
New-Item -Path $visualEffects -Force | Out-Null
Set-ItemProperty -Path $visualEffects -Name VisualFXSetting -Value 2

# Desativar animações específicas
$desktop = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $desktop -Name UserPreferencesMask -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00))
Set-ItemProperty -Path $desktop -Name DragFullWindows -Value 0
Set-ItemProperty -Path $desktop -Name FontSmoothing -Value 0

# ------------------------------------------------------------
# 6. Forçar tema clássico (sem Aero)
# ------------------------------------------------------------
Write-Host ">> Aplicando tema clássico"
Start-Process "C:\Windows\Resources\Ease of Access Themes\classic.theme"

# ------------------------------------------------------------
# 7. Otimizações de RDP (compressão + experiência WAN)
# ------------------------------------------------------------
Write-Host ">> Otimizando RDP para melhor desempenho"

# Habilitar compressão e priorizar desempenho
$rdpPolicy = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
New-Item -Path $rdpPolicy -Force | Out-Null

Set-ItemProperty -Path $rdpPolicy -Name fEnableVirtualizedGraphics -Value 0 -Type DWord
Set-ItemProperty -Path $rdpPolicy -Name fDisableCpm -Value 1 -Type DWord
Set-ItemProperty -Path $rdpPolicy -Name fDisableAudioCapture -Value 1 -Type DWord
Set-ItemProperty -Path $rdpPolicy -Name MaxCompressionLevel -Value 2 -Type DWord

# ------------------------------------------------------------
# 8. Desativar efeitos visuais na sessão RDP
# ------------------------------------------------------------
Write-Host ">> Desativando efeitos visuais em sessões remotas"

$rdpClient = "HKCU:\Software\Microsoft\Terminal Server Client"
New-Item -Path $rdpClient -Force | Out-Null
Set-ItemProperty -Path $rdpClient -Name DisableWallpaper -Value 1
Set-ItemProperty -Path $rdpClient -Name DisableFullWindowDrag -Value 1
Set-ItemProperty -Path $rdpClient -Name DisableMenuAnims -Value 1
Set-ItemProperty -Path $rdpClient -Name DisableThemes -Value 1

# ------------------------------------------------------------
# Finalização
# ------------------------------------------------------------
Write-Host "`nOtimizações aplicadas com sucesso!" -ForegroundColor Green
Write-Host "Reinicie o servidor para garantir que tudo entre em vigor." -ForegroundColor Yellow
