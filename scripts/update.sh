#!/bin/bash
# Script para atualizar as imagens Docker

set -e

echo "🔄 Atualizando imagens Docker..."
echo ""

# Puxar novas imagens
echo "📥 Baixando atualizações..."
docker compose pull

echo ""
echo "🔄 Recriando containers com novas imagens..."
docker compose up -d --force-recreate

echo ""
echo "🧹 Removendo imagens antigas..."
docker image prune -f

echo ""
echo "✅ Atualização concluída!"
echo ""
echo "📊 Status:"
docker compose ps

echo ""
