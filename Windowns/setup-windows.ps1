# Ativar execução de scripts para a sessão atual
Set-ExecutionPolicy Bypass -Scope Process -Force

# Função interativa para configurar o Git
function Configure-Git {
    Write-Host "`n🔧 Configurando Git..."
    $name = Read-Host "Digite seu nome para o Git"
    $email = Read-Host "Digite seu email para o Git"
    git config --global user.name "$name"
    git config --global user.email "$email"
    git config --global color.ui auto
    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.cm "commit -m"
    git config --global alias.hist "log --oneline --graph --decorate --all"
    Write-Host "✅ Git configurado com sucesso!"
}

# Função para instalar drivers de GPU (abre site oficial)
function Install-GPUDrivers {
    Write-Host "`n🧠 Detectando GPU..."
    $gpuInfo = Get-WmiObject Win32_VideoController | Select-Object -ExpandProperty Name

    if ($gpuInfo -match "NVIDIA") {
        Write-Host "🔧 Instalando drivers NVIDIA..."
        Start-Process "https://www.nvidia.com/Download/index.aspx"
    } elseif ($gpuInfo -match "AMD") {
        Write-Host "🔧 Instalando drivers AMD..."
        Start-Process "https://www.amd.com/en/support"
    } elseif ($gpuInfo -match "Intel") {
        Write-Host "🔧 Instalando drivers Intel..."
        Start-Process "https://www.intel.com/content/www/us/en/download-center/home.html"
    } else {
        Write-Host "❓ GPU não identificada. Faça a instalação manual."
    }
}

# Atualizar drivers via Windows Update
function Update-WindowsDrivers {
    Write-Host "`n🔄 Verificando e instalando drivers via Windows Update..."
    Install-Module PSWindowsUpdate -Force -Scope CurrentUser
    Import-Module PSWindowsUpdate
    Get-WindowsUpdate -AcceptAll -Install -AutoReboot
}

# Instalação de apps via Winget
Write-Host "`n🚀 Instalando aplicativos com Winget..."

$apps = @(
    "Git.Git",
    "Microsoft.VisualStudioCode",
    "Python.Python.3",
    "Node.js",
    "Oracle.JavaRuntimeEnvironment",
    "Microsoft.DotNet.SDK.7",
    "Steam.Steam",
    "Discord.Discord",
    "HeroicGamesLauncher.Heroic",
    "GOG.Galaxy",
    "Notion.Notion",
    "Anki.Anki",
    "Google.Chrome",
    "Mozilla.Firefox"
)

foreach ($app in $apps) {
    Write-Host "`n📦 Instalando: $app"
    winget install --id=$app --silent --accept-source-agreements --accept-package-agreements
}

# Instalar Epic Games Launcher manualmente
Write-Host "`n🎮 Instalando Epic Games Launcher..."
$epicInstaller = "$env:TEMP\EpicInstaller.msi"
Invoke-WebRequest -Uri "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi" -OutFile $epicInstaller
Start-Process msiexec.exe -ArgumentList "/i `"$epicInstaller`" /quiet" -Wait
Remove-Item $epicInstaller
Write-Host "✅ Epic Games Launcher instalado!"

# Configuração do Git
Configure-Git

# Atualizar drivers pelo Windows Update
Update-WindowsDrivers

# Detecção da GPU e link para driver
Install-GPUDrivers

Write-Host "`n🎉 Instalação concluída! Reinicie o sistema se necessário."
