Write-Host ">> Ajustando efeitos visuais"

$ve = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
New-Item -Path $ve -Force | Out-Null
Set-ItemProperty -Path $ve -Name VisualFXSetting -Value 2

$desktop = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $desktop -Name DragFullWindows -Value 0
Set-ItemProperty -Path $desktop -Name FontSmoothing -Value 0
