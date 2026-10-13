#!/bin/bash
# Script para backup dos modelos e dados

set -e

BACKUP_DIR=${1:-./backups}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="qwen-backup-${TIMESTAMP}.tar.gz"

echo "💾 Criando backup dos dados do Qwen..."
echo ""

# Criar diretório de backup
mkdir -p "$BACKUP_DIR"

echo "📦 Compactando volumes Docker..."
docker run --rm \
    -v qwen-local_ollama_data:/data \
    -v qwen-local_open_webui_data:/webui \
    -v "$(pwd)/$BACKUP_DIR":/backup \
    ubuntu tar czf "/backup/$BACKUP_FILE" /data /webui

echo ""
echo "✅ Backup criado com sucesso!"
echo ""
echo "📁 Arquivo: $BACKUP_DIR/$BACKUP_FILE"
echo "📊 Tamanho: $(du -h "$BACKUP_DIR/$BACKUP_FILE" | cut -f1)"
echo ""
echo "💡 Para restaurar: ./scripts/restore.sh $BACKUP_DIR/$BACKUP_FILE"
echo ""
