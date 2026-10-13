#!/bin/bash
# Script para parar o servidor Qwen

set -e

echo "🛑 Parando servidor Qwen..."

docker compose stop

echo ""
echo "✅ Serviços parados!"
echo ""
echo "💡 Para iniciar novamente: ./scripts/start.sh"
echo "💡 Para remover completamente: ./scripts/cleanup.sh"
echo ""
