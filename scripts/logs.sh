#!/bin/bash
# Script para visualizar logs

SERVICE=${1:-all}

echo "📝 Visualizando logs..."
echo ""

if [ "$SERVICE" = "all" ]; then
    docker compose logs -f --tail=100
elif [ "$SERVICE" = "ollama" ]; then
    docker compose logs -f --tail=100 ollama
elif [ "$SERVICE" = "webui" ]; then
    docker compose logs -f --tail=100 open-webui
else
    echo "❌ Serviço inválido!"
    echo ""
    echo "Uso: ./scripts/logs.sh [serviço]"
    echo ""
    echo "Serviços disponíveis:"
    echo "  - all (padrão) - Todos os logs"
    echo "  - ollama - Logs do Ollama"
    echo "  - webui - Logs do Open WebUI"
    echo ""
    exit 1
fi
