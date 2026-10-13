#!/bin/bash
# Script para limpar espaço do Docker

echo "🧹 Limpeza de Espaço Docker"
echo "==========================="
echo ""

echo "⚠️  Este script irá:"
echo "  1. Remover containers parados"
echo "  2. Remover imagens não utilizadas"
echo "  3. Remover redes não utilizadas"
echo "  4. Remover cache de build"
echo ""
echo "⚠️  NÃO irá remover:"
echo "  - Containers em execução"
echo "  - Volumes (seus modelos estão seguros)"
echo ""

read -p "Deseja continuar? (s/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Operação cancelada."
    exit 0
fi

echo ""
echo "📊 Espaço ANTES da limpeza:"
docker system df
echo ""

echo "🗑️ Removendo containers parados..."
docker container prune -f

echo ""
echo "🗑️ Removendo imagens não utilizadas..."
docker image prune -a -f

echo ""
echo "🗑️ Removendo redes não utilizadas..."
docker network prune -f

echo ""
echo "🗑️ Removendo cache de build..."
docker builder prune -f

echo ""
echo "✅ Limpeza concluída!"
echo ""
echo "📊 Espaço APÓS a limpeza:"
docker system df

echo ""
echo "💡 Espaço liberado com sucesso!"
