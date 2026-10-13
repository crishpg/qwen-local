#!/bin/bash
# Script para iniciar o servidor Qwen

set -e

echo "🚀 Iniciando servidor Qwen..."

# Verificar se Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Erro: Docker não está rodando!"
    echo "Execute: sudo systemctl start docker"
    exit 1
fi

# Verificar se arquivo .env existe
if [ ! -f .env ]; then
    echo "⚠️  Arquivo .env não encontrado. Copiando de .env.example..."
    cp .env.example .env
fi

# Iniciar serviços
docker compose up -d

echo ""
echo "✅ Serviços iniciados!"
echo ""
echo "📊 Status dos containers:"
docker compose ps

echo ""
echo "🌐 Acesso:"
echo "  - Interface Web: http://localhost:$(grep WEBUI_PORT .env | cut -d'=' -f2)"
echo "  - API Ollama: http://localhost:$(grep OLLAMA_PORT .env | cut -d'=' -f2)"
echo ""
echo "📝 Para ver logs: ./scripts/logs.sh"
echo "📊 Para monitorar recursos: ./scripts/monitor.sh"
echo ""
