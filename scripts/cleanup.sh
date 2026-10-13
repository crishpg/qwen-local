#!/bin/bash
# Script para limpar completamente o ambiente

echo "🗑️  Limpeza completa do ambiente Qwen"
echo ""
echo "⚠️  ATENÇÃO: Este processo irá:"
echo "  - Parar todos os containers"
echo "  - Remover todos os containers"
echo "  - Remover todos os volumes (PERDE TODOS OS MODELOS BAIXADOS)"
echo ""

read -p "Deseja continuar? (s/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Operação cancelada."
    exit 0
fi

echo ""
echo "🛑 Parando containers..."
docker compose down

read -p "Remover também os volumes (modelos baixados)? (s/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo ""
    echo "🗑️  Removendo volumes..."
    docker compose down -v
    echo "✅ Volumes removidos!"
fi

echo ""
echo "🧹 Limpando imagens não utilizadas..."
docker image prune -f

echo ""
echo "✅ Limpeza concluída!"
echo ""
echo "💡 Para iniciar novamente: ./scripts/start.sh"
echo ""
