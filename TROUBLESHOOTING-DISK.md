# 🔧 Solução: Erro de Espaço em Disco

## 🚨 Problema
Erro ao executar `docker compose up -d` relacionado a falta de espaço em disco.

## 🔍 Diagnóstico

### Passo 1: Verificar espaço disponível no servidor

Execute no seu servidor Ubuntu:

```bash
# Verificar espaço em disco geral
df -h

# Verificar especificamente o diretório raiz
df -h /

# Verificar espaço usado pelo Docker
docker system df
```

### Passo 2: Usar script de diagnóstico

```bash
# Tornar executável
chmod +x scripts/check-disk-space.sh

# Executar diagnóstico completo
./scripts/check-disk-space.sh
```

Isso mostrará:
- Espaço disponível no sistema
- Espaço usado por Docker (imagens, containers, volumes)
- Volumes existentes
- Containers existentes

## 🛠️ Soluções

### Solução 1: Limpeza Segura (Recomendada)

Use o script de limpeza que **não remove** volumes (modelos ficam seguros):

```bash
# Tornar executável
chmod +x scripts/cleanup-docker.sh

# Executar limpeza
./scripts/cleanup-docker.sh
```

Isso remove:
- ✅ Containers parados
- ✅ Imagens não utilizadas
- ✅ Redes não utilizadas
- ✅ Cache de build
- ❌ **NÃO** remove volumes (modelos seguros)

### Solução 2: Limpeza Manual

#### Remover apenas imagens não utilizadas
```bash
docker image prune -a
```

#### Remover containers parados
```bash
docker container prune
```

#### Remover cache de build
```bash
docker builder prune -a
```

#### Ver quanto espaço será liberado (sem remover)
```bash
docker system df -v
```

### Solução 3: Limpeza Completa (CUIDADO!)

⚠️ **Atenção**: Remove TUDO, incluindo volumes (você perderá modelos baixados)

```bash
# Para TUDO primeiro
docker compose down

# Limpeza total
docker system prune -a --volumes

# Depois precisará baixar modelos novamente
```

### Solução 4: Verificar Partição/Volume

Se o problema persistir, pode ser a partição do Docker:

```bash
# Ver onde Docker está armazenando dados
docker info | grep "Docker Root Dir"

# Verificar espaço dessa partição específica
df -h /var/lib/docker
```

Se `/var/lib/docker` está em partição separada e cheia:

```bash
# Ver uso detalhado
sudo du -sh /var/lib/docker/*

# Verificar se há espaço
df -h /var
```

## 📋 Checklist de Diagnóstico

Execute estes comandos no servidor e me envie o resultado:

```bash
# 1. Espaço total disponível
df -h | grep -E "Filesystem|/$"

# 2. Uso do Docker
docker system df

# 3. Listar imagens (ver tamanho)
docker images

# 4. Containers existentes
docker ps -a

# 5. Volumes existentes
docker volume ls
```

## 🎯 Soluções Específicas por Causa

### Se o problema for: "Disco raiz cheio"
```bash
# Verificar arquivos grandes
sudo du -h / | sort -rh | head -20

# Limpar logs do sistema
sudo journalctl --vacuum-time=3d

# Limpar cache do apt
sudo apt clean
```

### Se o problema for: "Muitas imagens Docker"
```bash
# Ver todas as imagens e tamanhos
docker images

# Remover imagens antigas do Ollama (se houver)
docker images | grep ollama | grep -v latest

# Remover imagem específica
docker rmi <IMAGE_ID>
```

### Se o problema for: "Containers antigos"
```bash
# Ver containers parados
docker ps -a -f status=exited

# Remover todos containers parados
docker container prune
```

## 🚀 Após Liberar Espaço

```bash
# 1. Verificar que há espaço suficiente (recomendado: 15GB livres)
df -h

# 2. Tentar novamente
docker compose up -d

# 3. Acompanhar download das imagens
docker compose logs -f
```

## 📊 Requisitos de Espaço

### Espaço Necessário (Mínimo)

| Item | Tamanho |
|------|---------|
| Sistema Ubuntu | 5-10 GB |
| Imagem Ollama | ~500 MB |
| Imagem Open WebUI | ~200 MB |
| Modelo qwen2.5:7b | ~4.5 GB |
| Buffer/Margem | ~5 GB |
| **TOTAL** | **~15 GB** |

### Espaço Recomendado

| Cenário | Espaço Livre |
|---------|--------------|
| 1 modelo pequeno (3B) | 10 GB |
| 1 modelo médio (7B) | 15 GB |
| 1 modelo grande (14B) | 20 GB |
| Múltiplos modelos | 30+ GB |

## 💡 Dicas de Prevenção

1. **Monitore regularmente**:
```bash
# Adicionar ao crontab para checar semanalmente
0 0 * * 0 docker system prune -f
```

2. **Use modelos quantizados** quando possível:
   - `qwen2.5:7b-q4_0` ao invés de `qwen2.5:7b`
   - Economiza ~50% de espaço

3. **Mantenha apenas modelos em uso**:
```bash
# Listar modelos
docker exec qwen-ollama ollama list

# Remover modelos não usados
docker exec qwen-ollama ollama rm <modelo-antigo>
```

4. **Configure limite de logs**:
```yaml
# No docker-compose.yml, adicionar:
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

## 🆘 Se Nada Funcionar

Se após todas as tentativas ainda houver erro:

1. **Verifique logs detalhados**:
```bash
docker compose up -d --verbose
# ou
docker compose logs
```

2. **Verifique permissões**:
```bash
ls -la /var/lib/docker
sudo chown -R root:docker /var/lib/docker
```

3. **Reinicie o Docker**:
```bash
sudo systemctl restart docker
```

4. **Me envie o output de**:
```bash
df -h
docker system df
docker compose up -d
# (copie o erro completo)
```

---

**Em caso de dúvidas, execute `./scripts/check-disk-space.sh` e me envie o resultado!**
