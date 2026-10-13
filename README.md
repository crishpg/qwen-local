# 🚀 Servidor Qwen Local - Ubuntu 22.04

Servidor Docker otimizado para rodar modelos Qwen (AI Open Source) localmente em Ubuntu 22.04 com 4 vCPUs e 16GB RAM, com acesso remoto via API REST.

## 📋 Índice

- [Características](#-características)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação](#-instalação)
- [Scripts Auxiliares](#-scripts-auxiliares)
- [Uso](#-uso)
- [Acesso Remoto](#-acesso-remoto)
- [Gerenciamento de Modelos](#-gerenciamento-de-modelos)
- [Monitoramento](#-monitoramento)
- [Troubleshooting](#-troubleshooting)

> 💡 **Quer começar rápido?** Veja o [QUICK_START.md](QUICK_START.md) para começar em 5 minutos!

## ✨ Características

- ✅ **Ollama** - Servidor de modelos LLM otimizado
- ✅ **Open WebUI** - Interface web moderna para interagir com os modelos
- ✅ **API REST** compatível com OpenAI
- ✅ Otimizado para **4 vCPUs e 16GB RAM**
- ✅ Configuração de limites de recursos
- ✅ Acesso remoto configurável
- ✅ Health checks automáticos
- ✅ Persistência de dados via volumes Docker

## 🔧 Pré-requisitos

### No servidor Ubuntu 22.04:

1. **Docker Engine** (versão 20.10 ou superior)
2. **Docker Compose** (versão 2.0 ou superior)

### Instalação do Docker no Ubuntu 22.04:

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependências
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Adicionar repositório oficial do Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Adicionar usuário ao grupo docker (para rodar sem sudo)
sudo usermod -aG docker $USER

# Reiniciar para aplicar as mudanças
# ou fazer logout/login
```

Verifique a instalação:
```bash
docker --version
docker compose version
```

## 📦 Instalação

### Instalação Automática (Recomendado)

```bash
# Tornar o script executável
chmod +x install.sh

# Executar instalação
./install.sh
```

O script `install.sh` irá:
- ✅ Verificar e instalar Docker/Docker Compose se necessário
- ✅ Configurar permissões do usuário
- ✅ Preparar todos os scripts
- ✅ Criar arquivo .env

### Instalação Manual

### 1. Clone ou copie os arquivos para o servidor

```bash
# Criar diretório
mkdir -p ~/qwen-local
cd ~/qwen-local

# Copiar arquivos: docker-compose.yml, .env, scripts/
```

### 2. Configure as variáveis de ambiente (opcional)

O arquivo `.env` já vem com configurações otimizadas. Você pode ajustar se necessário:

```bash
nano .env
```

Configurações principais:
- `OLLAMA_PORT=11434` - Porta da API Ollama
- `WEBUI_PORT=3000` - Porta da interface web
- `OLLAMA_NUM_PARALLEL=2` - Requisições paralelas
- `OLLAMA_MAX_LOADED_MODELS=1` - Modelos em memória (manter em 1)
- `WEBUI_AUTH=false` - Autenticação da interface web

### 3. Inicie os serviços

```bash
# Iniciar em background
docker compose up -d

# Ver logs em tempo real
docker compose logs -f
```

Aguarde alguns segundos para os serviços iniciarem completamente.

### 4. Baixe um modelo Qwen

**Modelos recomendados para 16GB RAM:**

```bash
# RECOMENDADO: Modelo balanceado (7B - ~4.5GB RAM)
docker exec -it qwen-ollama ollama pull qwen2.5:7b

# ALTERNATIVAS:
# Modelo pequeno e rápido (3B - ~2GB RAM)
docker exec -it qwen-ollama ollama pull qwen2.5:3b

# Modelo maior, melhor qualidade (14B - ~8GB RAM)
docker exec -it qwen-ollama ollama pull qwen2.5:14b

# Especializado em código (7B - ~4.5GB RAM)
docker exec -it qwen-ollama ollama pull qwen2.5-coder:7b

# Versão quantizada (menor qualidade, mais rápido - ~2.5GB RAM)
docker exec -it qwen-ollama ollama pull qwen2.5:7b-q4_0
```

⚠️ **EVITE modelos acima de 14B** - Eles requerem mais de 20GB de RAM.

## 🛠️ Scripts Auxiliares

Este projeto inclui diversos scripts para facilitar o gerenciamento. Todos estão na pasta `scripts/`:

### Gerenciamento Básico
```bash
./scripts/start.sh       # Inicia os serviços
./scripts/stop.sh        # Para os serviços
./scripts/restart.sh     # Reinicia os serviços
./scripts/status.sh      # Verifica status completo do sistema
```

### Monitoramento
```bash
./scripts/logs.sh [serviço]  # Visualiza logs (all, ollama, webui)
./scripts/monitor.sh         # Monitora recursos em tempo real
```

### Gerenciamento de Modelos
```bash
./scripts/models.sh list              # Lista modelos instalados
./scripts/models.sh pull <modelo>     # Baixa um modelo
./scripts/models.sh remove <modelo>   # Remove um modelo
./scripts/models.sh show <modelo>     # Mostra info do modelo
./scripts/models.sh test <modelo>     # Testa um modelo
./scripts/models.sh recommended       # Lista modelos recomendados
```

### Backup e Manutenção
```bash
./scripts/backup.sh [diretório]  # Cria backup dos dados
./scripts/restore.sh <arquivo>   # Restaura backup
./scripts/update.sh              # Atualiza imagens Docker
./scripts/cleanup.sh             # Limpeza completa
```

### Testes e Configuração
```bash
./scripts/test-api.sh [modelo] ["prompt"]  # Testa a API
./scripts/setup-firewall.sh                # Configura firewall UFW
./scripts/help.sh                          # Lista todos os comandos
```

Para ver todos os comandos disponíveis, execute:
```bash
./scripts/help.sh
```

## 🎯 Uso

### Interface Web (Open WebUI)

Acesse no navegador:
```
http://SEU_IP_SERVIDOR:3000
```

A interface permite:
- Chat interativo com os modelos
- Histórico de conversas
- Upload de documentos
- Gerenciamento de modelos

### API REST (compatível com OpenAI)

O Ollama expõe uma API REST na porta `11434`:

```bash
# Endpoint base
http://SEU_IP_SERVIDOR:11434

# Testar disponibilidade
curl http://localhost:11434/api/tags

# Fazer uma requisição (chat)
curl http://localhost:11434/api/chat -d '{
  "model": "qwen2.5:7b",
  "messages": [
    {
      "role": "user",
      "content": "Olá! Como você está?"
    }
  ],
  "stream": false
}'

# Fazer uma requisição (completion)
curl http://localhost:11434/api/generate -d '{
  "model": "qwen2.5:7b",
  "prompt": "Explique o que é Docker em uma frase.",
  "stream": false
}'
```

### Exemplo em Python

```python
import requests
import json

url = "http://SEU_IP_SERVIDOR:11434/api/chat"

payload = {
    "model": "qwen2.5:7b",
    "messages": [
        {"role": "user", "content": "Escreva um poema sobre IA"}
    ],
    "stream": False
}

response = requests.post(url, json=payload)
result = response.json()
print(result['message']['content'])
```

### Exemplo em JavaScript/Node.js

```javascript
const axios = require('axios');

async function chat(prompt) {
    const response = await axios.post('http://SEU_IP_SERVIDOR:11434/api/chat', {
        model: 'qwen2.5:7b',
        messages: [
            { role: 'user', content: prompt }
        ],
        stream: false
    });
    
    return response.data.message.content;
}

chat('Qual a capital do Brasil?').then(console.log);
```

## 🌐 Acesso Remoto

### 1. Configurar Firewall (UFW)

```bash
# Permitir portas necessárias
sudo ufw allow 11434/tcp comment 'Ollama API'
sudo ufw allow 3000/tcp comment 'Open WebUI'

# Verificar regras
sudo ufw status

# Habilitar firewall (se ainda não estiver)
sudo ufw enable
```

### 2. Acessar de outro computador

```bash
# Interface Web
http://IP_DO_SERVIDOR:3000

# API
http://IP_DO_SERVIDOR:11434
```

### 3. Configurar domínio (opcional)

Se você tem um domínio, pode usar Nginx como proxy reverso:

```bash
sudo apt install nginx

# Criar configuração
sudo nano /etc/nginx/sites-available/qwen
```

Conteúdo:
```nginx
server {
    listen 80;
    server_name seu-dominio.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    location /api {
        proxy_pass http://localhost:11434;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
    }
}
```

Ativar:
```bash
sudo ln -s /etc/nginx/sites-available/qwen /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## 🎛️ Gerenciamento de Modelos

### Listar modelos instalados

```bash
docker exec -it qwen-ollama ollama list
```

### Baixar novos modelos

```bash
docker exec -it qwen-ollama ollama pull <nome-do-modelo>
```

### Remover modelos

```bash
docker exec -it qwen-ollama ollama rm <nome-do-modelo>
```

### Ver informações do modelo

```bash
docker exec -it qwen-ollama ollama show qwen2.5:7b
```

### Testar modelo via CLI

```bash
docker exec -it qwen-ollama ollama run qwen2.5:7b "Olá, como você está?"
```

## 📊 Monitoramento

### Ver logs dos serviços

```bash
# Todos os serviços
docker compose logs -f

# Apenas Ollama
docker compose logs -f ollama

# Apenas WebUI
docker compose logs -f open-webui

# Últimas 100 linhas
docker compose logs --tail=100
```

### Verificar status dos containers

```bash
docker compose ps
```

### Monitorar recursos (CPU, RAM)

```bash
# Em tempo real
docker stats

# Específico do Ollama
docker stats qwen-ollama
```

### Ver uso de disco dos volumes

```bash
docker system df -v
```

### Health check

```bash
# Status do Ollama
curl http://localhost:11434/api/tags

# Status via Docker
docker compose ps
```

## 🔄 Comandos Úteis

### Parar serviços

```bash
docker compose stop
```

### Iniciar serviços

```bash
docker compose start
```

### Reiniciar serviços

```bash
docker compose restart
```

### Parar e remover tudo (CUIDADO: perde dados não salvos)

```bash
docker compose down
```

### Parar e remover incluindo volumes (CUIDADO: perde modelos baixados)

```bash
docker compose down -v
```

### Atualizar imagens

```bash
docker compose pull
docker compose up -d
```

### Backup dos modelos

```bash
# Criar backup
docker run --rm -v qwen-local_ollama_data:/data -v $(pwd):/backup ubuntu tar czf /backup/ollama-backup.tar.gz /data

# Restaurar backup
docker run --rm -v qwen-local_ollama_data:/data -v $(pwd):/backup ubuntu tar xzf /backup/ollama-backup.tar.gz -C /
```

## 🐛 Troubleshooting

### Container não inicia

```bash
# Ver logs detalhados
docker compose logs

# Verificar se portas já estão em uso
sudo netstat -tulpn | grep -E ':(11434|3000)'

# Liberar porta se necessário
sudo kill -9 <PID>
```

### Modelo não carrega (erro de memória)

- Use modelos menores (3B ou 7B quantizados)
- Verifique se apenas 1 modelo está configurado: `OLLAMA_MAX_LOADED_MODELS=1`
- Reduza `OLLAMA_NUM_PARALLEL` para 1
- Feche outros aplicativos que consomem RAM

### Performance lenta

1. **Use modelos quantizados** (q4_0 ou q5_0)
2. **Ajuste o número de threads**:
```bash
# Editar .env
OLLAMA_NUM_THREAD=4
```
3. **Reduza o tamanho do contexto** nas requisições:
```json
{
  "model": "qwen2.5:7b",
  "options": {
    "num_ctx": 2048
  }
}
```

### Não consigo acessar remotamente

1. Verifique o firewall:
```bash
sudo ufw status
```

2. Teste conexão local primeiro:
```bash
curl http://localhost:11434/api/tags
```

3. Verifique se o Docker está escutando em todas as interfaces:
```bash
docker compose ps
```

### Espaço em disco cheio

```bash
# Limpar imagens não utilizadas
docker system prune -a

# Ver uso de espaço
docker system df

# Remover modelos antigos
docker exec -it qwen-ollama ollama rm <modelo-antigo>
```

### Container reiniciando constantemente

```bash
# Ver logs de erro
docker compose logs --tail=50 ollama

# Verificar health check
docker inspect qwen-ollama | grep -A 10 Health
```

## 📚 Recursos Adicionais

- [Documentação Ollama](https://github.com/ollama/ollama)
- [Documentação Open WebUI](https://github.com/open-webui/open-webui)
- [Modelos Qwen](https://huggingface.co/Qwen)
- [API Ollama](https://github.com/ollama/ollama/blob/main/docs/api.md)

## 🔒 Segurança

### Recomendações para produção:

1. **Habilitar autenticação na WebUI**:
```bash
# No arquivo .env
WEBUI_AUTH=true
```

2. **Usar HTTPS** (com Nginx + Let's Encrypt)

3. **Restringir acesso via firewall** a IPs conhecidos:
```bash
sudo ufw allow from 192.168.1.0/24 to any port 11434
```

4. **Monitorar logs de acesso** regularmente

5. **Manter Docker e imagens atualizadas**

## 📝 Licença

Este projeto usa componentes Open Source:
- Ollama: MIT License
- Open WebUI: MIT License
- Modelos Qwen: Apache 2.0 License

---

**Criado para rodar em Ubuntu 22.04 com 4 vCPUs e 16GB RAM** 🐧🚀
