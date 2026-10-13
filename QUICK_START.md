# ⚡ Guia de Início Rápido - Servidor Qwen

Este guia permite que você tenha o servidor Qwen rodando em **5 minutos**.

## 🚀 Instalação em 3 Passos

### 1️⃣ Instalar Docker e Configurar Ambiente

```bash
# Tornar o script de instalação executável
chmod +x install.sh

# Executar instalação automática
./install.sh
```

O script irá:
- ✅ Instalar Docker e Docker Compose (se necessário)
- ✅ Configurar permissões do usuário
- ✅ Preparar todos os scripts
- ✅ Criar arquivo de configuração .env

**⚠️ IMPORTANTE:** Se você foi adicionado ao grupo docker, execute:
```bash
newgrp docker
# OU faça logout/login
```

### 2️⃣ Iniciar o Servidor

```bash
# Iniciar serviços
./scripts/start.sh
```

Aguarde cerca de 30 segundos para os serviços iniciarem completamente.

### 3️⃣ Baixar um Modelo Qwen

```bash
# Baixar modelo recomendado (7B - 4.5GB)
./scripts/models.sh pull qwen2.5:7b
```

**Outros modelos disponíveis:**
```bash
# Modelo pequeno e rápido (3B - 2GB)
./scripts/models.sh pull qwen2.5:3b

# Modelo maior com melhor qualidade (14B - 8GB)
./scripts/models.sh pull qwen2.5:14b

# Modelo especializado em código (7B - 4.5GB)
./scripts/models.sh pull qwen2.5-coder:7b
```

---

## ✅ Pronto! Agora você pode usar:

### 🌐 Interface Web
Abra no navegador:
```
http://localhost:3000
```

### 🔌 API REST
Teste com curl:
```bash
curl http://localhost:11434/api/generate -d '{
  "model": "qwen2.5:7b",
  "prompt": "Olá! Como você está?",
  "stream": false
}'
```

---

## 🛠️ Comandos Essenciais

```bash
# Ver status
./scripts/status.sh

# Ver logs em tempo real
./scripts/logs.sh

# Monitorar recursos (CPU/RAM)
./scripts/monitor.sh

# Listar modelos instalados
./scripts/models.sh list

# Parar servidor
./scripts/stop.sh

# Reiniciar servidor
./scripts/restart.sh

# Ver todos os comandos disponíveis
./scripts/help.sh
```

---

## 🌍 Acesso Remoto (Opcional)

### Configurar Firewall

```bash
# Executar script de configuração
chmod +x scripts/setup-firewall.sh
./scripts/setup-firewall.sh
```

### Acessar de Outro Computador

```bash
# Descobrir IP do servidor
ip addr show | grep "inet " | grep -v 127.0.0.1

# Acessar de outro computador
http://SEU_IP_SERVIDOR:3000        # Interface Web
http://SEU_IP_SERVIDOR:11434       # API
```

---

## 🧪 Testar o Modelo

### Via Script
```bash
./scripts/test-api.sh qwen2.5:7b "Qual a capital do Brasil?"
```

### Via Interface de Linha de Comando
```bash
docker exec -it qwen-ollama ollama run qwen2.5:7b "Escreva um poema sobre IA"
```

### Via Python
```python
import requests

response = requests.post('http://localhost:11434/api/generate', json={
    "model": "qwen2.5:7b",
    "prompt": "Explique Docker em uma frase",
    "stream": False
})

print(response.json()['response'])
```

---

## 📊 Verificar Status

```bash
# Status completo do sistema
./scripts/status.sh
```

Saída esperada:
```
📊 Status do Servidor Qwen
================================

🐳 Containers:
  ✅ qwen-ollama: running
  ✅ qwen-webui: running

🔍 Teste de conectividade:
  ✅ API Ollama: Online
  ✅ Open WebUI: Online

🤖 Modelos instalados:
  qwen2.5:7b
```

---

## ❓ Problemas Comuns

### Erro: "Cannot connect to Docker daemon"
```bash
# Iniciar Docker
sudo systemctl start docker

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
newgrp docker
```

### Erro: "Out of memory"
- Use modelos menores (qwen2.5:3b ou versões quantizadas)
- Verifique configuração no .env: `OLLAMA_MAX_LOADED_MODELS=1`

### Porta já em uso
```bash
# Verificar quem está usando a porta
sudo netstat -tulpn | grep 11434

# Alterar porta no arquivo .env
nano .env
# Mudar OLLAMA_PORT=11434 para outro valor
```

---

## 📚 Próximos Passos

1. ✅ Explore a **Interface Web**: http://localhost:3000
2. ✅ Leia a **documentação completa**: [README.md](README.md)
3. ✅ Configure **acesso remoto** (se necessário)
4. ✅ Faça **backup dos modelos**: `./scripts/backup.sh`
5. ✅ Configure como **serviço do sistema**: ver `qwen.service.example`

---

## 💡 Dicas

- **Economizar memória**: Use modelos quantizados (q4_0)
- **Melhor qualidade**: Use qwen2.5:14b (requer 8GB RAM livre)
- **Programação**: Use qwen2.5-coder:7b
- **Performance**: Ajuste `OLLAMA_NUM_PARALLEL` no .env

---

**🎉 Divirta-se com seu servidor de IA local!**

Para mais informações, consulte [README.md](README.md) ou execute `./scripts/help.sh`
