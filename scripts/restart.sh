#!/bin/bash
# Script para reiniciar o servidor Qwen

set -e

echo "🔄 Reiniciando servidor Qwen..."

docker compose restart

echo ""
echo "✅ Serviços reiniciados!"
echo ""
echo "📊 Status dos containers:"
docker compose ps

echo ""
echo "📝 Para ver logs: ./scripts/logs.sh"
echo ""
