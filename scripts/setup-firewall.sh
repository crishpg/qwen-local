#!/bin/bash
# Script para configurar firewall (UFW) para acesso remoto

echo "🔥 Configuração de Firewall para Servidor Qwen"
echo "==============================================="
echo ""

# Verificar se UFW está instalado
if ! command -v ufw &> /dev/null; then
    echo "❌ UFW não está instalado!"
    echo ""
    read -p "Deseja instalar o UFW? (s/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        sudo apt update
        sudo apt install -y ufw
        echo "✅ UFW instalado!"
    else
        echo "Instalação cancelada."
        exit 0
    fi
fi

echo "⚠️  Este script irá:"
echo "  - Permitir acesso SSH (porta 22)"
echo "  - Permitir acesso à API Ollama (porta 11434)"
echo "  - Permitir acesso à Interface Web (porta 3000)"
echo ""

read -p "Deseja continuar? (s/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Configuração cancelada."
    exit 0
fi

echo ""
echo "🔧 Configurando regras do firewall..."

# Permitir SSH (importante para não perder acesso remoto!)
echo "✓ Permitindo SSH (porta 22)..."
sudo ufw allow 22/tcp comment 'SSH'

# Permitir API Ollama
echo "✓ Permitindo API Ollama (porta 11434)..."
sudo ufw allow 11434/tcp comment 'Ollama API'

# Permitir Interface Web
echo "✓ Permitindo Interface Web (porta 3000)..."
sudo ufw allow 3000/tcp comment 'Open WebUI'

echo ""
echo "📋 Regras configuradas:"
sudo ufw show added

echo ""
read -p "Deseja habilitar o firewall agora? (s/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo ""
    echo "🚀 Habilitando firewall..."
    sudo ufw --force enable
    echo ""
    echo "✅ Firewall habilitado!"
else
    echo ""
    echo "⚠️  Firewall configurado mas não habilitado."
    echo "Para habilitar manualmente: sudo ufw enable"
fi

echo ""
echo "📊 Status do firewall:"
sudo ufw status verbose

echo ""
echo "================================================"
echo "✅ Configuração concluída!"
echo "================================================"
echo ""
echo "💡 Comandos úteis:"
echo "  - Ver status: sudo ufw status"
echo "  - Desabilitar: sudo ufw disable"
echo "  - Ver logs: sudo tail -f /var/log/ufw.log"
echo ""
echo "🔒 SEGURANÇA:"
echo "  - Para restringir acesso a IPs específicos:"
echo "    sudo ufw delete allow 11434/tcp"
echo "    sudo ufw allow from 192.168.1.0/24 to any port 11434"
echo ""
