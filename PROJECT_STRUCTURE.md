# 📁 Estrutura do Projeto

```
qwen-local/
├── 📄 docker-compose.yml          # Configuração dos serviços Docker
├── 📄 .env                         # Variáveis de ambiente (local, não versionado)
├── 📄 .env.example                 # Template de configuração
├── 📄 .gitignore                   # Arquivos ignorados pelo Git
├── 📄 install.sh                   # Script de instalação automática
├── 📄 qwen.service.example         # Template para serviço systemd
│
├── 📖 README.md                    # Documentação completa
├── 📖 QUICK_START.md               # Guia de início rápido
├── 📖 PROJECT_STRUCTURE.md         # Este arquivo
│
└── 📂 scripts/                     # Scripts de gerenciamento
    ├── start.sh                    # Iniciar serviços
    ├── stop.sh                     # Parar serviços
    ├── restart.sh                  # Reiniciar serviços
    ├── status.sh                   # Verificar status
    ├── logs.sh                     # Visualizar logs
    ├── monitor.sh                  # Monitorar recursos
    ├── models.sh                   # Gerenciar modelos
    ├── backup.sh                   # Criar backup
    ├── restore.sh                  # Restaurar backup
    ├── update.sh                   # Atualizar imagens
    ├── cleanup.sh                  # Limpeza completa
    ├── test-api.sh                 # Testar API
    ├── setup-firewall.sh           # Configurar firewall
    └── help.sh                     # Ajuda (lista comandos)
```

## 📝 Descrição dos Arquivos

### Configuração Principal

#### `docker-compose.yml`
Define dois serviços:
- **ollama**: Servidor de modelos LLM (porta 11434)
  - Limites: 4 CPUs, 14GB RAM
  - Volume persistente para modelos
  - Health checks automáticos
- **open-webui**: Interface web (porta 3000)
  - Limites: 1 CPU, 2GB RAM
  - Volume persistente para dados do usuário
  - Conectado ao Ollama

#### `.env`
Variáveis de configuração:
- `OLLAMA_PORT`: Porta da API (padrão: 11434)
- `WEBUI_PORT`: Porta da interface web (padrão: 3000)
- `OLLAMA_NUM_PARALLEL`: Requisições paralelas (padrão: 2)
- `OLLAMA_MAX_LOADED_MODELS`: Modelos em memória (padrão: 1)
- `OLLAMA_KEEP_ALIVE`: Tempo de cache do modelo (padrão: 5m)
- `WEBUI_AUTH`: Autenticação na interface (padrão: false)

#### `.env.example`
Template para criar o arquivo `.env`. Copiar e ajustar conforme necessário.

### Documentação

#### `README.md`
Documentação completa incluindo:
- Instalação do Docker no Ubuntu 22.04
- Configuração detalhada
- Exemplos de uso (API REST, Python, JavaScript)
- Acesso remoto e segurança
- Troubleshooting

#### `QUICK_START.md`
Guia rápido para começar em 5 minutos:
- Instalação em 3 passos
- Comandos essenciais
- Testes básicos

#### `PROJECT_STRUCTURE.md`
Este arquivo - documentação da estrutura do projeto.

### Instalação

#### `install.sh`
Script de instalação automática que:
- Verifica sistema operacional
- Instala Docker e Docker Compose (se necessário)
- Configura permissões do usuário
- Torna scripts executáveis
- Cria arquivo .env a partir do template
- Inicia serviço Docker

#### `qwen.service.example`
Template para criar serviço systemd, permitindo:
- Iniciar automaticamente no boot
- Gerenciar com systemctl
- Logs através do journalctl

### Scripts de Gerenciamento

#### Básicos
- **`start.sh`**: Inicia containers em background, verifica Docker, mostra status
- **`stop.sh`**: Para containers sem remover dados
- **`restart.sh`**: Reinicia containers, útil após mudanças no .env

#### Monitoramento
- **`status.sh`**: Status completo (containers, conectividade, modelos, recursos)
- **`logs.sh`**: Visualiza logs com filtro por serviço (all/ollama/webui)
- **`monitor.sh`**: Monitoramento em tempo real de CPU/RAM/IO

#### Modelos
- **`models.sh`**: Gerenciamento completo de modelos
  - `list`: Lista modelos instalados
  - `pull`: Baixa novo modelo
  - `remove`: Remove modelo
  - `show`: Informações detalhadas
  - `test`: Teste rápido com prompt
  - `recommended`: Lista modelos recomendados para o hardware

#### Backup e Manutenção
- **`backup.sh`**: Cria backup compactado dos volumes Docker
- **`restore.sh`**: Restaura backup (com confirmação)
- **`update.sh`**: Atualiza imagens Docker para versões mais recentes
- **`cleanup.sh`**: Remove containers, volumes e imagens (com confirmação)

#### Testes e Configuração
- **`test-api.sh`**: Testa API com curl, aceita modelo e prompt customizados
- **`setup-firewall.sh`**: Configura UFW para acesso remoto (portas 22, 3000, 11434)
- **`help.sh`**: Lista todos os scripts disponíveis com descrições

## 🔧 Volumes Docker

Os dados persistentes são armazenados em volumes Docker:

```
qwen-local_ollama_data         # Modelos baixados (~4-8GB por modelo)
qwen-local_open_webui_data     # Conversas e configurações da interface
```

### Localização dos Volumes
```bash
# Ver localização dos volumes
docker volume inspect qwen-local_ollama_data
docker volume inspect qwen-local_open_webui_data

# Geralmente em:
# /var/lib/docker/volumes/qwen-local_ollama_data/_data
# /var/lib/docker/volumes/qwen-local_open_webui_data/_data
```

### Backup de Volumes
```bash
# Criar backup
./scripts/backup.sh

# Resultado: backups/qwen-backup-YYYYMMDD_HHMMSS.tar.gz
```

## 🌐 Portas Utilizadas

| Porta | Serviço | Descrição |
|-------|---------|-----------|
| 11434 | Ollama API | API REST para inferência |
| 3000 | Open WebUI | Interface web do usuário |

**Nota**: As portas podem ser alteradas no arquivo `.env`

## 🔐 Segurança

### Arquivos Sensíveis
- `.env` - Contém configurações (não versionado no Git)
- Volumes Docker - Contém modelos e dados (fazer backup regularmente)

### Boas Práticas
1. Configure autenticação na interface web (`WEBUI_AUTH=true`)
2. Use firewall para restringir acesso
3. Configure HTTPS com Nginx para produção
4. Mantenha Docker e imagens atualizados
5. Faça backups regulares

## 📊 Requisitos de Espaço

### Espaço em Disco Necessário

| Item | Tamanho Aproximado |
|------|-------------------|
| Imagem Docker Ollama | ~500MB |
| Imagem Docker Open WebUI | ~200MB |
| Modelo qwen2.5:3b | ~2GB |
| Modelo qwen2.5:7b | ~4.5GB |
| Modelo qwen2.5:14b | ~8GB |
| Modelo qwen2.5-coder:7b | ~4.5GB |
| Dados da interface web | ~100MB |

**Recomendado**: Pelo menos **15GB livres** no disco para operação confortável.

## 🚀 Fluxo de Uso Típico

### Primeira Instalação
```bash
1. chmod +x install.sh
2. ./install.sh
3. newgrp docker (se necessário)
4. ./scripts/start.sh
5. ./scripts/models.sh pull qwen2.5:7b
6. Acessar http://localhost:3000
```

### Uso Diário
```bash
# Verificar status
./scripts/status.sh

# Ver logs se necessário
./scripts/logs.sh

# Gerenciar modelos
./scripts/models.sh list
```

### Manutenção Semanal
```bash
# Backup
./scripts/backup.sh

# Verificar atualizações
./scripts/update.sh

# Monitorar recursos
./scripts/monitor.sh
```

## 📚 Referências

- [Ollama GitHub](https://github.com/ollama/ollama)
- [Open WebUI GitHub](https://github.com/open-webui/open-webui)
- [Modelos Qwen](https://huggingface.co/Qwen)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [Ollama API Docs](https://github.com/ollama/ollama/blob/main/docs/api.md)

---

**Criado para Ubuntu 22.04 com 4 vCPUs e 16GB RAM** 🐧🚀
