Write-Host ">> Reduzindo impacto do Windows Defender"

# Proteção em tempo real OFF
Set-MpPreference -DisableRealtimeMonitoring $true

# Cloud protection OFF
Set-MpPreference -MAPSReporting 0
Set-MpPreference -SubmitSamplesConsent 2

# Excluir tudo do sistema (RDP desktop)
Set-MpPreference -ExclusionPath "C:\"
