Write-Host "`n🚀 Aplicando Performance Mode..."

# Plano Alto Desempenho
powercfg -setactive SCHEME_MIN

# Desativar transparência
Set-ItemProperty `
  "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
  -Name EnableTransparency -Value 0 -ErrorAction SilentlyContinue

# Melhor desempenho visual
$ve = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
New-Item -Path $ve -Force | Out-Null
Set-ItemProperty -Path $ve -Name VisualFXSetting -Value 2

# Desativar SysMain
if (Get-Service SysMain -ErrorAction SilentlyContinue) {
    Stop-Service SysMain -Force
    Set-Service SysMain -StartupType Disabled
}

# Desativar Windows Search
if (Get-Service WSearch -ErrorAction SilentlyContinue) {
    Stop-Service WSearch -Force
    Set-Service WSearch -StartupType Disabled
}

Write-Host "✔ Performance Mode aplicado"
