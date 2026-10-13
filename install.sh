#!/bin/bash
# Script de instalação rápida para Ubuntu 22.04

set -e

echo "🚀 Instalação do Servidor Qwen Local"
echo "====================================="
echo ""

# Verificar se está rodando no Ubuntu
if [ ! -f /etc/os-release ]; then
    echo "⚠️  Aviso: Não foi possível detectar o sistema operacional"
else
    . /etc/os-release
    if [ "$ID" != "ubuntu" ]; then
        echo "⚠️  Aviso: Este script foi feito para Ubuntu 22.04"
        echo "Sistema detectado: $NAME $VERSION"
        read -p "Deseja continuar mesmo assim? (s/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            exit 0
        fi
    fi
fi

echo "📋 Etapas da instalação:"
echo "  1. Verificar/Instalar Docker"
echo "  2. Configurar permissões"
echo "  3. Tornar scripts executáveis"
echo "  4. Iniciar serviços"
echo ""
read -p "Deseja continuar? (s/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Instalação cancelada."
    exit 0
fi

echo ""
echo "🔍 Verificando Docker..."

# Verificar se Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker não encontrado. Instalando..."
    echo ""
    
    # Atualizar sistema
    echo "📦 Atualizando sistema..."
    sudo apt update
    
    # Instalar dependências
    echo "📦 Instalando dependências..."
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    
    # Adicionar repositório Docker
    echo "📦 Adicionando repositório Docker..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Instalar Docker
    echo "📦 Instalando Docker..."
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    
    echo "✅ Docker instalado com sucesso!"
else
    echo "✅ Docker já está instalado"
fi

# Verificar Docker Compose
echo ""
echo "🔍 Verificando Docker Compose..."
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose não encontrado!"
    echo "Execute: sudo apt install docker-compose-plugin"
    exit 1
else
    echo "✅ Docker Compose já está instalado"
fi

# Adicionar usuário ao grupo docker
echo ""
echo "👤 Configurando permissões..."
if groups $USER | grep -q docker; then
    echo "✅ Usuário já está no grupo docker"
else
    echo "📝 Adicionando usuário ao grupo docker..."
    sudo usermod -aG docker $USER
    echo "⚠️  IMPORTANTE: Faça logout/login ou reinicie para aplicar as mudanças"
    echo "Ou execute: newgrp docker"
fi

# Tornar scripts executáveis
echo ""
echo "🔧 Configurando scripts..."
chmod +x scripts/*.sh
chmod +x install.sh
echo "✅ Scripts configurados"

# Verificar arquivo .env
echo ""
if [ ! -f .env ]; then
    echo "📝 Criando arquivo .env..."
    cp .env.example .env
    echo "✅ Arquivo .env criado"
else
    echo "✅ Arquivo .env já existe"
fi

# Iniciar Docker se não estiver rodando
echo ""
echo "🔍 Verificando serviço Docker..."
if ! sudo systemctl is-active --quiet docker; then
    echo "🚀 Iniciando Docker..."
    sudo systemctl start docker
    sudo systemctl enable docker
fi
echo "✅ Docker está rodando"

echo ""
echo "================================================"
echo "✅ Instalação concluída com sucesso!"
echo "================================================"
echo ""
echo "🚀 Próximos passos:"
echo ""
echo "1. Se você foi adicionado ao grupo docker agora, execute:"
echo "   newgrp docker"
echo "   (ou faça logout/login)"
echo ""
echo "2. Inicie o servidor:"
echo "   ./scripts/start.sh"
echo ""
echo "3. Baixe um modelo Qwen:"
echo "   ./scripts/models.sh pull qwen2.5:7b"
echo ""
echo "4. Acesse a interface web:"
echo "   http://localhost:3000"
echo ""
echo "5. Para ver todos os comandos disponíveis:"
echo "   ./scripts/help.sh"
echo ""
echo "📚 Consulte o README.md para mais informações"
echo ""
