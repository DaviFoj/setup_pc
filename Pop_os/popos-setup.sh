#!/bin/bash

echo "🚀 Iniciando configuração do ambiente gamer + dev no Pop!_OS..."

echo "🔄 Atualizando o sistema..."
sudo apt update && sudo apt full-upgrade -y

echo "🖥️ Detecção de drivers gráficos..."

echo "Qual driver de vídeo você deseja instalar?"
echo "1) NVIDIA"
echo "2) AMD"
echo "3) Intel"
read -p "Escolha (1/2/3): " gpu_choice

case $gpu_choice in
  1)
    echo "🔧 Instalando drivers NVIDIA..."
    sudo apt install -y nvidia-driver-535
    ;;
  2)
    echo "🔧 Instalando drivers AMD (mesa)..."
    sudo apt install -y mesa-vulkan-drivers
    ;;
  3)
    echo "🔧 Instalando drivers Intel (mesa)..."
    sudo apt install -y mesa-vulkan-drivers
    ;;
  *)
    echo "⚠️ Opção inválida. Nenhum driver específico será instalado."
    ;;
esac

echo "📦 Instalando pacotes essenciais..."
sudo apt install -y curl wget git build-essential apt-transport-https software-properties-common gnome-software gnome-software-plugin-flatpak

echo "🧑‍💻 Instalando linguagens e ambientes de desenvolvimento..."
sudo apt install -y python3 python3-pip gcc g++ default-jdk nodejs npm mono-complete

echo "⚙️ Instalando .NET SDK (C#)..."
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update
sudo apt install -y dotnet-sdk-7.0

echo "📁 Instalando VS Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | \
sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
sudo apt update
sudo apt install -y code
rm microsoft.gpg

echo "🎮 Instalando Steam..."
sudo apt install -y steam

echo "🎙️ Instalando Discord..."
wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y ./discord.deb
rm discord.deb

echo "🕹️ Instalando Heroic (Epic Games + GOG)..."
sudo flatpak install -y flathub com.heroicgameslauncher.hgl

echo "🍷 Instalando Wine e Lutris..."
sudo apt install -y wine64
sudo add-apt-repository ppa:lutris-team/lutris -y
sudo apt update
sudo apt install -y lutris

echo "🎮 Instalando ProtonUp-Qt (Proton-GE e Wine-GE)..."
flatpak install -y flathub net.davidotek.pupgui2

echo "📦 Instalando Notion (alternativo)..."
wget -O notion.deb https://github.com/jaredallard/notion-app/releases/latest/download/notion-app_amd64.deb
sudo apt install -y ./notion.deb
rm notion.deb

echo "📚 Instalando Anki..."
sudo apt install -y anki

echo "🦉 Duolingo: acessar via navegador - https://www.duolingo.com"

echo "🎮 Instalando bibliotecas extras para compatibilidade com jogos..."
sudo apt install -y libvulkan1 mesa-vulkan-drivers vulkan-utils \
    libgl1-mesa-dri libgl1-mesa-glx libglfw3

echo "🔧 Ativando suporte a 32-bit (para Wine/GOG/Steam)..."
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y libgl1-mesa-glx:i386 libgl1-mesa-dri:i386 libvulkan1:i386 wine32

echo "🔧 Configurando Git..."

read -p "Digite seu nome para o Git: " nome
read -p "Digite seu email para o Git: " email
git config --global user.name "$nome"
git config --global user.email "$email"

git config --global color.ui auto
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm "commit -m"
git config --global alias.hist "log --oneline --graph --decorate --all"

if [ -f /etc/bash_completion.d/git ]; then
    echo "source /etc/bash_completion.d/git" >> ~/.bashrc
fi

echo "✅ Instalação finalizada com sucesso!"
echo "🔁 Reinicie seu sistema para aplicar todas as mudanças."
