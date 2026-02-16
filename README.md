# Winlabs Tweaks – Windows Homelab Baseline

Projeto voltado para padronização e otimização de sistemas Windows utilizados em **Home Lab**, com foco em:

* Uso como **desktop via RDP**
* Redução de consumo de recursos
* Minimização de telemetria e bloat
* Manutenção da estabilidade
* Estrutura modular e reutilizável

O objetivo não é “quebrar o Windows”, mas **domar o sistema com segurança**, mantendo compatibilidade e previsibilidade.

---

# Sistemas Suportados

### Windows Server

* Windows Server 2012 R2
* Windows Server 2016

### Windows Desktop

* Windows 10 LTSC 2021
* Windows 10 Home / Pro
* Windows 11 Home / Pro

Cada sistema recebe ajustes apropriados ao seu comportamento e arquitetura.

---

# Filosofia do Projeto

Este projeto segue cinco princípios:

1. **Modularidade**
   Cada versão do Windows possui seus próprios ajustes específicos.

2. **Segurança antes de agressividade**
   Nenhum tweak remove componentes críticos como:

   * RPC
   * Winlogon
   * DWM
   * Serviços de perfil de usuário
   * Serviços essenciais de rede

3. **Compatibilidade com Update**
   Em Windows 10/11 e Server 2016+, o Windows Update não é removido, apenas controlado via política.

4. **RDP-first mindset**
   As otimizações priorizam:

   * Responsividade remota
   * Baixo uso de RAM
   * Menos animações
   * Compressão RDP otimizada

5. **Transparência**
   Todas as alterações são feitas via:

   * Chaves de política (HKLM\SOFTWARE\Policies)
   * Serviços documentados
   * Configurações suportadas oficialmente

Nada obscuro ou irreversível.

---

# Estrutura de Diretórios

```
winlabs/
│
├── main.ps1
│
├── common/
│   ├── power.ps1
│   ├── visual.ps1
│   ├── rdp.ps1
│   └── services-desktop.ps1
│
├── win2012r2/
│   └── windowsupdate.ps1
│
├── win2016/
│   └── windowsupdate.ps1
│
├── win10-ltsc2021/
│   ├── windowsupdate.ps1
│   ├── defender.ps1
│   └── services.ps1
│
└── win10-11/
    ├── baseline.ps1
    └── performance.ps1
```

## main.ps1

Script principal responsável por:

* Detectar automaticamente o sistema operacional
* Carregar os módulos apropriados
* Aplicar apenas os ajustes compatíveis

---

# O que o Projeto Otimiza

## 1. Energia

* Ativa plano Alto Desempenho
* Evita throttling desnecessário

## 2. Interface

* Desativa transparências
* Ajusta efeitos para “Melhor desempenho”
* Remove animações

## 3. RDP

* Ajusta compressão
* Remove efeitos visuais remotos
* Desabilita recursos não necessários em sessões

## 4. Telemetria e Bloat (Windows 10/11)

* AllowTelemetry = 1 (nível mínimo seguro)
* DisableWindowsConsumerFeatures
* DisableInventoryCollector
* DisableWebSearch
* Bloqueio de recursos online no menu iniciar
* Desativação de DiagTrack e dmwappushservice

## 5. Serviços Removidos (quando seguro)

Exemplos:

* SysMain
* Windows Search
* DiagTrack
* RetailDemo
* MapsBroker
* Location Services
* RemoteRegistry

Nenhum serviço crítico de login ou rede é alterado.

---

# Execução do Projeto

1. Copie a pasta do projeto para o sistema alvo.
2. Execute o PowerShell como Administrador.
3. Rode:

```
.\main.ps1
```

Reinicie o sistema após aplicação.

---

# PowerShell Execution Policy

Por padrão, o Windows pode bloquear scripts.

Para permitir execução temporária na sessão atual:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Para permitir permanentemente para o usuário atual:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

Para restaurar para o padrão:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted
```

Para entender melhor as políticas:

```powershell
Get-Help about_Execution_Policies
```

Recomenda-se utilizar `RemoteSigned` para equilíbrio entre segurança e praticidade.

---

# Perfil de Uso Recomendado

## Melhor desempenho absoluto em RDP

Windows Server 2012 R2

## Uso com internet e suporte ativo

Windows Server 2016

## Desktop moderno controlado

Windows 10 LTSC 2021

## Desktop geral Home/Pro

Windows 10 ou 11 com baseline aplicado

---

# Limitações Conhecidas

* DWM não pode ser removido em versões modernas.
* Defender em Windows 10/11 não deve ser completamente desinstalado.

---

# Boas Práticas Recomendadas

* Utilize snapshots antes de aplicar mudanças.
* Mantenha backups.
* Documente alterações específicas do seu ambiente.
* Não utilize modo agressivo em máquinas de produção.

---

# Agradecimentos

Agradecimento especial ao canal **1155 do ET** pelas configurações de gpedit e configurações voltadas para Windows 10 e Windows 11.

As configurações de política aplicadas neste projeto foram inspiradas nas idéias apresentadas no video:

[https://www.youtube.com/watch?v=kQM-iv7TQz0](https://www.youtube.com/watch?v=kQM-iv7TQz0)

Incluindo ajustes realizados via gpedit.msc como:

* Configuração mínima de telemetria
* Desativação de recursos de consumidor
* Bloqueio de busca online
* Controle de inventário
* Configurações de localização
* Ajustes de Microsoft Store

Também agradecimento pelo PDF disponibilizado no vídeo, que serviu como base estruturada para consolidação das políticas no modo automatizado via registro.

---

# Contribuições

Colaborações são bem-vindas.

Sugestões, melhorias, correções e novos perfis de otimização podem ser submetidos via:

* Pull request
* Issue documentada
* Sugestões de benchmark

O objetivo é evoluir este projeto para se tornar uma baseline sólida para homelabs e ambientes de teste controlados ou em ultimo caso para uso em computadores com recursos reduzidos.
