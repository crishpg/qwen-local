#!/bin/bash
# Script para gerenciar modelos Qwen

COMMAND=${1:-list}
MODEL_NAME=$2

case $COMMAND in
    list)
        echo "🤖 Modelos instalados:"
        echo ""
        docker exec qwen-ollama ollama list
        ;;
    
    pull)
        if [ -z "$MODEL_NAME" ]; then
            echo "❌ Erro: Nome do modelo não fornecido!"
            echo ""
            echo "Uso: ./scripts/models.sh pull <nome-do-modelo>"
            echo ""
            echo "Modelos recomendados para 16GB RAM:"
            echo "  - qwen2.5:7b (Recomendado - 4.5GB)"
            echo "  - qwen2.5:3b (Pequeno - 2GB)"
            echo "  - qwen2.5:14b (Grande - 8GB)"
            echo "  - qwen2.5-coder:7b (Código - 4.5GB)"
            echo "  - qwen2.5:7b-q4_0 (Quantizado - 2.5GB)"
            echo ""
            exit 1
        fi
        
        echo "📥 Baixando modelo: $MODEL_NAME"
        echo ""
        docker exec -it qwen-ollama ollama pull "$MODEL_NAME"
        echo ""
        echo "✅ Modelo baixado com sucesso!"
        ;;
    
    rm|remove)
        if [ -z "$MODEL_NAME" ]; then
            echo "❌ Erro: Nome do modelo não fornecido!"
            echo ""
            echo "Uso: ./scripts/models.sh remove <nome-do-modelo>"
            echo ""
            exit 1
        fi
        
        echo "🗑️  Removendo modelo: $MODEL_NAME"
        docker exec qwen-ollama ollama rm "$MODEL_NAME"
        echo ""
        echo "✅ Modelo removido!"
        ;;
    
    show|info)
        if [ -z "$MODEL_NAME" ]; then
            echo "❌ Erro: Nome do modelo não fornecido!"
            echo ""
            echo "Uso: ./scripts/models.sh show <nome-do-modelo>"
            echo ""
            exit 1
        fi
        
        echo "ℹ️  Informações do modelo: $MODEL_NAME"
        echo ""
        docker exec qwen-ollama ollama show "$MODEL_NAME"
        ;;
    
    test)
        if [ -z "$MODEL_NAME" ]; then
            echo "❌ Erro: Nome do modelo não fornecido!"
            echo ""
            echo "Uso: ./scripts/models.sh test <nome-do-modelo>"
            echo ""
            exit 1
        fi
        
        echo "🧪 Testando modelo: $MODEL_NAME"
        echo ""
        docker exec -it qwen-ollama ollama run "$MODEL_NAME" "Olá! Me diga em uma frase o que você pode fazer."
        ;;
    
    recommended)
        echo "⭐ Modelos Qwen recomendados para 16GB RAM:"
        echo ""
        echo "🟢 RECOMENDADO:"
        echo "  qwen2.5:7b - Modelo balanceado (4.5GB RAM)"
        echo "    Melhor equilíbrio entre qualidade e velocidade"
        echo ""
        echo "🔵 ALTERNATIVAS:"
        echo "  qwen2.5:3b - Modelo pequeno (2GB RAM)"
        echo "    Mais rápido, menor qualidade"
        echo ""
        echo "  qwen2.5:14b - Modelo grande (8GB RAM)"
        echo "    Melhor qualidade, mais lento"
        echo ""
        echo "  qwen2.5-coder:7b - Especializado em código (4.5GB RAM)"
        echo "    Otimizado para programação"
        echo ""
        echo "  qwen2.5:7b-q4_0 - Versão quantizada (2.5GB RAM)"
        echo "    Menor qualidade, mais rápido"
        echo ""
        echo "⚠️  EVITE: qwen2.5:32b ou superior (requer mais de 20GB RAM)"
        echo ""
        echo "Para baixar: ./scripts/models.sh pull <nome-do-modelo>"
        ;;
    
    *)
        echo "❌ Comando inválido: $COMMAND"
        echo ""
        echo "Uso: ./scripts/models.sh <comando> [argumentos]"
        echo ""
        echo "Comandos disponíveis:"
        echo "  list - Lista modelos instalados"
        echo "  pull <modelo> - Baixa um modelo"
        echo "  remove <modelo> - Remove um modelo"
        echo "  show <modelo> - Mostra informações do modelo"
        echo "  test <modelo> - Testa um modelo com prompt simples"
        echo "  recommended - Lista modelos recomendados"
        echo ""
        echo "Exemplos:"
        echo "  ./scripts/models.sh list"
        echo "  ./scripts/models.sh pull qwen2.5:7b"
        echo "  ./scripts/models.sh test qwen2.5:7b"
        echo "  ./scripts/models.sh recommended"
        echo ""
        exit 1
        ;;
esac
