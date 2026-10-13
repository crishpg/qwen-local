#!/bin/bash
# Script para diagnosticar espaço em disco no servidor

echo "🔍 Diagnóstico de Espaço em Disco"
echo "=================================="
echo ""

echo "📊 Espaço em Disco Geral:"
df -h | grep -E "Filesystem|/$|/var"
echo ""

echo "🐳 Uso do Docker:"
docker system df
echo ""

echo "📦 Diretório Docker Root:"
docker info 2>/dev/null | grep "Docker Root Dir"
echo ""

echo "💾 Volumes Docker:"
docker volume ls
echo ""

echo "🗂️ Espaço ocupado por volumes:"
docker system df -v | grep -A 20 "Local Volumes"
echo ""

echo "🖼️ Imagens Docker:"
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
echo ""

echo "📦 Containers (incluindo parados):"
docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Size}}"
echo ""

echo "💡 Sugestões de Limpeza:"
echo "------------------------"
echo "1. Remover imagens não utilizadas:"
echo "   docker image prune -a"
echo ""
echo "2. Remover containers parados:"
echo "   docker container prune"
echo ""
echo "3. Remover volumes não utilizados:"
echo "   docker volume prune"
echo ""
echo "4. Limpeza completa (cuidado!):"
echo "   docker system prune -a --volumes"
echo ""

echo "🔍 Arquivos grandes no sistema (top 10):"
du -ah /var/lib/docker 2>/dev/null | sort -rh | head -10 || echo "Necessário sudo para verificar /var/lib/docker"
