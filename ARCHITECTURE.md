# 🏗️ Arquitetura do Sistema

## 📐 Visão Geral

```
┌─────────────────────────────────────────────────────────────┐
│                    SERVIDOR UBUNTU 22.04                    │
│                   4 vCPUs │ 16GB RAM                        │
└─────────────────────────────────────────────────────────────┘
                              │
                              │
┌─────────────────────────────────────────────────────────────┐
│                      DOCKER ENGINE                          │
│                                                             │
│  ┌───────────────────────────────────────────────────┐    │
│  │          REDE: qwen-network (bridge)              │    │
│  │                                                     │    │
│  │  ┌──────────────────────┐  ┌───────────────────┐ │    │
│  │  │   Container: Ollama  │  │ Container: WebUI  │ │    │
│  │  │                      │  │                   │ │    │
│  │  │  Image: ollama/      │  │ Image: open-webui│ │    │
│  │  │         ollama       │  │        /open-webui│ │    │
│  │  │                      │  │                   │ │    │
│  │  │  Recursos:           │  │ Recursos:         │ │    │
│  │  │  • Max: 4 CPUs       │  │ • Max: 1 CPU      │ │    │
│  │  │  • Max: 14GB RAM     │  │ • Max: 2GB RAM    │ │    │
│  │  │  • Min: 2 CPUs       │  │                   │ │    │
│  │  │  • Min: 8GB RAM      │  │                   │ │    │
│  │  │                      │  │                   │ │    │
│  │  │  Portas:             │  │ Portas:           │ │    │
│  │  │  • 11434 → 11434     │  │ • 3000 → 8080     │ │    │
│  │  │                      │  │                   │ │    │
│  │  │  Volume:             │  │ Volume:           │ │    │
│  │  │  ollama_data         │  │ open_webui_data   │ │    │
│  │  └──────────────────────┘  └───────────────────┘ │    │
│  │           │                         │            │    │
│  │           └─────────────────────────┘            │    │
│  │                      │                           │    │
│  └──────────────────────│───────────────────────────┘    │
│                         │                                │
└─────────────────────────│────────────────────────────────┘
                          │
                          │
         ┌────────────────┴────────────────┐
         │                                 │
    Porta 11434                       Porta 3000
     (API REST)                    (Interface Web)
         │                                 │
         │                                 │
    ┌────▼─────┐                    ┌─────▼────┐
    │  Clientes │                    │ Navegador│
    │  (Python, │                    │   Web    │
    │   JS, etc)│                    │          │
    └──────────┘                    └──────────┘
```

## 🔧 Componentes

### 1. Ollama (Servidor de Modelos)

**Função**: Servidor de inferência de modelos LLM

**Características**:
- Gerencia modelos de linguagem (download, cache, execução)
- API REST compatível com padrões da indústria
- Otimização automática para CPU
- Sistema de cache inteligente
- Suporte a quantização

**Configurações Chave**:
```yaml
Porta: 11434
CPU: 2-4 cores
RAM: 8-14 GB
Volume: ollama_data (~20GB+)
Health Check: GET /api/tags a cada 30s
```

**Variáveis de Ambiente**:
- `OLLAMA_HOST`: Bind em todas interfaces (0.0.0.0)
- `OLLAMA_NUM_PARALLEL`: Requisições paralelas (2)
- `OLLAMA_MAX_LOADED_MODELS`: Modelos em memória (1)
- `OLLAMA_KEEP_ALIVE`: Tempo de cache (5m)

### 2. Open WebUI (Interface do Usuário)

**Função**: Interface web moderna para interação com modelos

**Características**:
- Chat interativo com histórico
- Upload de documentos
- Gerenciamento de modelos
- Personalização de prompts
- Sistema de autenticação (opcional)

**Configurações Chave**:
```yaml
Porta Externa: 3000
Porta Interna: 8080
CPU: até 1 core
RAM: até 2 GB
Volume: open_webui_data (~1GB)
Dependência: ollama (health check)
```

**Variáveis de Ambiente**:
- `OLLAMA_BASE_URL`: URL do Ollama (http://ollama:11434)
- `WEBUI_AUTH`: Autenticação (false/true)

## 🔄 Fluxo de Dados

### 1. Requisição via Interface Web

```
Usuário → Navegador (porta 3000)
           ↓
      Open WebUI Container
           ↓
      Rede Docker (qwen-network)
           ↓
      Ollama Container (porta interna 11434)
           ↓
      Modelo Qwen (carregado na RAM)
           ↓
      Processamento (CPU)
           ↓
      Resposta ← Ollama
           ↓
      Resposta ← Open WebUI
           ↓
      Resposta ← Navegador
```

### 2. Requisição via API REST

```
Cliente (Python/JS/curl) → Porta 11434
                             ↓
                      Ollama Container
                             ↓
                      Modelo Qwen
                             ↓
                      Processamento
                             ↓
                      Resposta (JSON)
                             ↓
                      Cliente
```

## 💾 Persistência de Dados

### Volumes Docker

```
/var/lib/docker/volumes/
├── qwen-local_ollama_data/
│   └── _data/
│       ├── models/              # Modelos baixados (.gguf)
│       │   └── blobs/
│       │       ├── sha256-xxxx  # Arquivos do modelo
│       │       └── sha256-yyyy
│       └── manifests/           # Metadados dos modelos
│
└── qwen-local_open_webui_data/
    └── _data/
        ├── config.json          # Configurações
        ├── chats.db             # Histórico de conversas
        └── uploads/             # Arquivos enviados
```

### Tamanho dos Volumes

| Volume | Conteúdo | Tamanho Típico |
|--------|----------|----------------|
| ollama_data | Modelos Qwen | 5-15GB |
| open_webui_data | Conversas e configs | 100-500MB |

## 🌐 Rede e Portas

### Rede Docker Bridge (qwen-network)

```
Subnet: 172.18.0.0/16 (padrão Docker)

Containers:
├── ollama         172.18.0.2
└── open-webui     172.18.0.3

Comunicação:
- Interna: containers se comunicam por nome (DNS interno)
- Externa: host expõe portas 11434 e 3000
```

### Mapeamento de Portas

| Serviço | Host | Container | Protocolo |
|---------|------|-----------|-----------|
| Ollama API | 11434 | 11434 | TCP |
| Open WebUI | 3000 | 8080 | TCP |

## 📊 Uso de Recursos

### Distribuição de Memória (16GB Total)

```
┌─────────────────────────────────────────┐
│ Sistema Operacional: ~2GB               │ 2GB
├─────────────────────────────────────────┤
│ Docker Engine: ~500MB                   │ 0.5GB
├─────────────────────────────────────────┤
│ Ollama Container:                       │
│   - Base: ~500MB                        │
│   - Modelo 7B: ~4.5GB                   │
│   - Overhead: ~1GB                      │ 6GB
├─────────────────────────────────────────┤
│ Open WebUI Container: ~1-2GB            │ 2GB
├─────────────────────────────────────────┤
│ Buffers/Cache: ~5.5GB                   │ 5.5GB
└─────────────────────────────────────────┘
Total: 16GB
```

### Distribuição de CPU (4 vCPUs)

```
┌────────────────────────────────────────┐
│ Sistema: 0.5-1 vCPU                    │ 25%
├────────────────────────────────────────┤
│ Ollama: 2-4 vCPUs (dinamicamente)     │ 50-100%
├────────────────────────────────────────┤
│ Open WebUI: 0.1-0.5 vCPU              │ 5-15%
└────────────────────────────────────────┘
```

## 🔐 Segurança

### Camadas de Segurança

```
┌──────────────────────────────────────────┐
│ Nível 1: Firewall (UFW)                 │
│   - Portas específicas                   │
│   - IP whitelisting (opcional)           │
├──────────────────────────────────────────┤
│ Nível 2: Proxy Reverso (Nginx)          │
│   - HTTPS/TLS                            │
│   - Rate limiting                        │
│   - Header security                      │
├──────────────────────────────────────────┤
│ Nível 3: Autenticação (Open WebUI)      │
│   - Login/senha                          │
│   - JWT tokens                           │
├──────────────────────────────────────────┤
│ Nível 4: Isolamento (Docker)            │
│   - Network isolation                    │
│   - Resource limits                      │
│   - Container security                   │
└──────────────────────────────────────────┘
```

## 🚀 Inicialização

### Sequência de Boot

```
1. Docker Engine Start
   ↓
2. Criar/Verificar Rede (qwen-network)
   ↓
3. Criar/Verificar Volumes
   ↓
4. Iniciar Ollama Container
   ↓
5. Health Check Ollama (aguardar ready)
   ↓
6. Iniciar Open WebUI Container
   ↓
7. Sistema Pronto
```

### Tempos Típicos

| Etapa | Tempo |
|-------|-------|
| Pull de imagens (primeira vez) | 2-5 min |
| Inicialização Ollama | 10-20s |
| Inicialização WebUI | 5-10s |
| Carregar modelo 7B | 5-15s |
| **Total (primeira execução)** | **3-6 min** |
| **Total (execuções seguintes)** | **30-45s** |

## 📈 Escalabilidade

### Limitações Atuais

```
Hardware: 4 vCPUs, 16GB RAM
├── Modelos simultâneos: 1
├── Requisições paralelas: 2
├── Usuários simultâneos: ~5-10
└── Throughput: ~1-3 tokens/seg
```

### Melhorias Possíveis

**8 vCPUs, 32GB RAM**:
- Modelos simultâneos: 2
- Requisições paralelas: 4
- Usuários: ~15-20
- Throughput: ~3-5 tokens/seg

**GPU (ex: RTX 3060 12GB)**:
- Modelos simultâneos: 2-3
- Requisições paralelas: 8+
- Usuários: ~50+
- Throughput: ~20-50 tokens/seg

## 🔍 Monitoramento

### Métricas Chave

```yaml
Sistema:
  - CPU Usage
  - RAM Usage
  - Disk I/O
  - Network Traffic

Ollama:
  - Model Load Time
  - Tokens/Second
  - Request Queue
  - Cache Hit Rate

WebUI:
  - Active Users
  - Request Latency
  - Error Rate
```

### Comandos de Monitoramento

```bash
# Recursos em tempo real
docker stats

# Status completo
./scripts/status.sh

# Logs
./scripts/logs.sh

# Health checks
curl http://localhost:11434/api/tags
```

## 📚 Referências Técnicas

- [Docker Compose Specification](https://docs.docker.com/compose/compose-file/)
- [Ollama Architecture](https://github.com/ollama/ollama)
- [Open WebUI Architecture](https://github.com/open-webui/open-webui)
- [Qwen Model Details](https://huggingface.co/Qwen)

---

**Arquitetura otimizada para Ubuntu 22.04 com 4 vCPUs e 16GB RAM** 🏗️
