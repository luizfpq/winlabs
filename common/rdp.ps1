Write-Host ">> Otimizando RDP"

$ts = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
New-Item -Path $ts -Force | Out-Null

Set-ItemProperty -Path $ts -Name fDisableCpm -Value 1 -Type DWord
Set-ItemProperty -Path $ts -Name fDisableAudioCapture -Value 1 -Type DWord
Set-ItemProperty -Path $ts -Name MaxCompressionLevel -Value 2 -Type DWord
