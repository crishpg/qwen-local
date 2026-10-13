#!/bin/bash
# Script para testar a API do Ollama

MODEL=${1:-qwen2.5:7b}
PROMPT=${2:-"Olá! Responda em uma frase curta: o que você pode fazer?"}

echo "🧪 Testando API Ollama"
echo "======================"
echo ""
echo "Modelo: $MODEL"
echo "Prompt: $PROMPT"
echo ""
echo "Resposta:"
echo "----------"

curl -s http://localhost:11434/api/generate -d "{
  \"model\": \"$MODEL\",
  \"prompt\": \"$PROMPT\",
  \"stream\": false
}" | jq -r '.response'

echo ""
echo "----------"
echo ""
echo "✅ Teste concluído!"
echo ""
echo "💡 Para testar com outro modelo:"
echo "   ./scripts/test-api.sh <modelo> \"<seu prompt>\""
echo ""
