#!/bin/bash
# Script para restaurar backup

set -e

BACKUP_FILE=$1

if [ -z "$BACKUP_FILE" ]; then
    echo "❌ Erro: Arquivo de backup não fornecido!"
    echo ""
    echo "Uso: ./scripts/restore.sh <caminho-do-backup.tar.gz>"
    echo ""
    echo "Backups disponíveis:"
    ls -lh backups/*.tar.gz 2>/dev/null || echo "  Nenhum backup encontrado"
    echo ""
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Erro: Arquivo não encontrado: $BACKUP_FILE"
    exit 1
fi

echo "⚠️  ATENÇÃO: Este processo irá sobrescrever os dados atuais!"
read -p "Deseja continuar? (s/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Operação cancelada."
    exit 0
fi

echo ""
echo "🔄 Parando serviços..."
docker compose stop

echo ""
echo "📦 Restaurando backup..."
docker run --rm \
    -v qwen-local_ollama_data:/data \
    -v qwen-local_open_webui_data:/webui \
    -v "$(pwd)/$(dirname "$BACKUP_FILE")":/backup \
    ubuntu tar xzf "/backup/$(basename "$BACKUP_FILE")" -C /

echo ""
echo "🚀 Reiniciando serviços..."
docker compose start

echo ""
echo "✅ Backup restaurado com sucesso!"
echo ""
