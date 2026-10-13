#!/bin/bash
# Script para verificar status do servidor

echo "📊 Status do Servidor Qwen"
echo "================================"
echo ""

# Status dos containers
echo "🐳 Containers:"
docker compose ps

echo ""
echo "================================"
echo ""

# Verificar se Ollama está respondendo
echo "🔍 Teste de conectividade:"
if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo "  ✅ API Ollama: Online"
else
    echo "  ❌ API Ollama: Offline"
fi

if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "  ✅ Open WebUI: Online"
else
    echo "  ❌ Open WebUI: Offline"
fi

echo ""
echo "================================"
echo ""

# Listar modelos instalados
echo "🤖 Modelos instalados:"
if docker exec qwen-ollama ollama list 2>/dev/null; then
    echo ""
else
    echo "  ⚠️  Não foi possível listar modelos (container não está rodando)"
    echo ""
fi

echo "================================"
echo ""

# Uso de recursos
echo "💻 Uso de recursos:"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"

echo ""
