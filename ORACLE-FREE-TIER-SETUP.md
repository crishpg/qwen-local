# 🎁 Guia: Configurar Qwen no Oracle Cloud Free Tier (GRÁTIS!)

## 🌟 Por Que Oracle Cloud Free Tier?

Oracle oferece **GRATUITAMENTE e PARA SEMPRE**:
- ✅ **4 vCPUs ARM** (Ampere Altra)
- ✅ **24 GB RAM** (50% a mais que o necessário!)
- ✅ **200 GB Storage** (5x mais que o necessário!)
- ✅ **10 TB Bandwidth/mês**
- ✅ **IP Público gratuito**
- ✅ **Sem cartão de crédito após trial** (em alguns casos)
- ✅ **$0/mês PERMANENTEMENTE**

**Perfeito para rodar Qwen 24/7 sem custos!** 🚀

---

## 📋 Índice

1. [Criar Conta Oracle Cloud](#1-criar-conta-oracle-cloud)
2. [Criar Instância VM](#2-criar-instância-vm)
3. [Configurar Rede e Firewall](#3-configurar-rede-e-firewall)
4. [Conectar via SSH](#4-conectar-via-ssh)
5. [Instalar Docker](#5-instalar-docker)
6. [Instalar Qwen](#6-instalar-qwen)
7. [Configurar Acesso Remoto](#7-configurar-acesso-remoto)
8. [Solução de Problemas](#8-solução-de-problemas)

---

## 1. Criar Conta Oracle Cloud

### Passo 1.1: Cadastro
1. Acesse: https://www.oracle.com/cloud/free/
2. Clique em **"Start for free"**
3. Preencha seus dados:
   - País
   - Nome e sobrenome
   - Email (será usado para login)
   - Senha forte

### Passo 1.2: Verificação
1. Verifique seu email (código de confirmação)
2. **Importante**: Escolha região **permanente** (não pode mudar depois)
   - Recomendado: **São Paulo (Brazil East)** ou **Ashburn (US East)**
3. Forneça informações de pagamento (apenas para verificação)
   - ⚠️ **NÃO será cobrado** no Free Tier
   - Alguns podem pular essa etapa

### Passo 1.3: Aguardar Aprovação
- Pode levar de **minutos a 24 horas**
- Você receberá email quando aprovado

---

## 2. Criar Instância VM

### Passo 2.1: Acessar Console
1. Faça login em: https://cloud.oracle.com/
2. Vá para: **Menu (≡) → Compute → Instances**
3. Clique em **"Create Instance"**

### Passo 2.2: Configuração Básica
```
Nome: qwen-server
Availability Domain: Deixe padrão
```

### Passo 2.3: Escolher Imagem
```
Image: Ubuntu 22.04 (LTS)
  - Clique em "Change Image"
  - Selecione "Canonical Ubuntu"
  - Versão: 22.04 Minimal aarch64
```

### Passo 2.4: Escolher Shape (IMPORTANTE!)
```
Shape: Ampere (ARM-based)
  - Clique em "Change Shape"
  - Selecione "VM.Standard.A1.Flex" (Free Tier Eligible)
  
Configuração:
  - OCPUs: 4 (máximo gratuito)
  - Memory (GB): 24 (máximo gratuito)
```

⚠️ **ATENÇÃO**: Se não aparecer opção ARM, a região pode estar sem capacidade. Tente:
- Horários diferentes (madrugada costuma ter mais disponibilidade)
- Outra Availability Domain
- Outra região (se possível)

### Passo 2.5: Rede
```
Virtual cloud network: Deixe criar automaticamente
Subnet: Public Subnet (padrão)
Public IP: Assign a public IPv4 address ✅
```

### Passo 2.6: Chave SSH
```
Add SSH keys:
  ○ Generate SSH key pair (recomendado)
    - Clique em "Save Private Key" 
    - Salve como: qwen-oracle.key
    - Guarde em local seguro!
  
  OU
  
  ○ Upload public key file (se já tiver)
  ○ Paste public keys (colar conteúdo .pub)
```

### Passo 2.7: Boot Volume
```
Boot volume size (GB): 100 GB
  - Use volume-based boot volume: ✅
  - Encryption: Use Oracle-managed keys
```

### Passo 2.8: Criar!
1. Clique em **"Create"**
2. Aguarde provisioning (2-5 minutos)
3. **Status**: RUNNING (bolinha verde)
4. **Anote o IP Público** (aparece na tela)

---

## 3. Configurar Rede e Firewall

### Passo 3.1: Configurar Security List (Oracle Cloud)

1. Na página da instância, clique em **Virtual Cloud Network**
2. Clique em **Security Lists**
3. Clique na Security List padrão
4. Clique em **"Add Ingress Rules"**

**Adicionar estas regras:**

#### Regra 1: SSH (se não existir)
```
Stateless: ☐ No
Source Type: CIDR
Source CIDR: 0.0.0.0/0
IP Protocol: TCP
Source Port Range: All
Destination Port Range: 22
Description: SSH access
```

#### Regra 2: API Ollama
```
Stateless: ☐ No
Source Type: CIDR
Source CIDR: 0.0.0.0/0
IP Protocol: TCP
Source Port Range: All
Destination Port Range: 11434
Description: Ollama API
```

#### Regra 3: Web Interface
```
Stateless: ☐ No
Source Type: CIDR
Source CIDR: 0.0.0.0/0
IP Protocol: TCP
Source Port Range: All
Destination Port Range: 3000
Description: Open WebUI
```

5. Clique em **"Add Ingress Rules"**

### Passo 3.2: Configurar Firewall do Ubuntu (iptables)

Você fará isso após conectar via SSH (próxima seção).

---

## 4. Conectar via SSH

### No Linux/Mac:

```bash
# Dar permissão à chave privada
chmod 400 ~/Downloads/qwen-oracle.key

# Conectar (substitua SEU_IP pelo IP público)
ssh -i ~/Downloads/qwen-oracle.key ubuntu@SEU_IP_PUBLICO
```

### No Windows:

#### Opção A: PowerShell (Windows 10+)
```powershell
# Conectar (substitua o caminho da chave e o IP)
ssh -i C:\Users\SEU_USUARIO\Downloads\qwen-oracle.key ubuntu@SEU_IP_PUBLICO
```

#### Opção B: PuTTY
1. Baixe PuTTY: https://www.putty.org/
2. Converta chave .key para .ppk usando PuTTYgen
3. Use a chave .ppk no PuTTY para conectar

### Primeira Conexão:
```
The authenticity of host '...' can't be established.
Are you sure you want to continue connecting (yes/no)? yes
```

✅ **Conectado!** Você verá prompt: `ubuntu@qwen-server:~$`

---

## 5. Instalar Docker

### Passo 5.1: Atualizar Sistema
```bash
sudo apt update
sudo apt upgrade -y
```

### Passo 5.2: Instalar Docker
```bash
# Instalar dependências
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Adicionar repositório Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Adicionar usuário ao grupo docker
sudo usermod -aG docker ubuntu

# Aplicar mudanças (logout/login)
newgrp docker

# Verificar instalação
docker --version
docker compose version
```

### Passo 5.3: Configurar Firewall Ubuntu
```bash
# Permitir portas necessárias
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 11434 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 3000 -j ACCEPT

# Salvar regras
sudo netfilter-persistent save

# Se netfilter-persistent não estiver instalado:
sudo apt install -y iptables-persistent
```

---

## 6. Instalar Qwen

### Passo 6.1: Clonar Repositório
```bash
# Clonar projeto
git clone https://github.com/crishpg/qwen-local.git
cd qwen-local

# Tornar scripts executáveis
chmod +x scripts/*.sh install.sh
```

### Passo 6.2: Verificar Espaço
```bash
# Deve mostrar ~100GB disponível
df -h /
```

### Passo 6.3: Iniciar Servidor
```bash
# Iniciar containers
./scripts/start.sh

# Aguardar 30 segundos
sleep 30

# Verificar status
./scripts/status.sh
```

### Passo 6.4: Baixar Modelo Qwen
```bash
# Modelo recomendado (7B - 4.5GB)
docker exec -it qwen-ollama ollama pull qwen2.5:7b

# OU modelo menor (3B - 2GB) se preferir mais rápido
# docker exec -it qwen-ollama ollama pull qwen2.5:3b

# OU modelo maior (14B - 8GB) para melhor qualidade
# docker exec -it qwen-ollama ollama pull qwen2.5:14b

# Aguardar download completar (pode levar 5-15 min)
```

### Passo 6.5: Testar
```bash
# Testar API
curl http://localhost:11434/api/tags

# Testar modelo
docker exec -it qwen-ollama ollama run qwen2.5:7b "Olá! Me diga em uma frase o que você pode fazer."
```

---

## 7. Configurar Acesso Remoto

### Passo 7.1: Obter IP Público

```bash
# Ver seu IP público
curl ifconfig.me
```

### Passo 7.2: Acessar de Qualquer Lugar

**Interface Web:**
```
http://SEU_IP_PUBLICO:3000
```

**API REST:**
```
http://SEU_IP_PUBLICO:11434
```

### Passo 7.3: Testar da Sua Máquina Local

```bash
# Testar API (substitua o IP)
curl http://SEU_IP_PUBLICO:11434/api/tags

# Gerar texto
curl http://SEU_IP_PUBLICO:11434/api/generate -d '{
  "model": "qwen2.5:7b",
  "prompt": "Explique Docker em uma frase",
  "stream": false
}'
```

---

## 8. Solução de Problemas

### Problema: "No capacity available"

**Solução**: Região sem capacidade ARM no momento.

```bash
# Tente:
1. Horários diferentes (madrugada tem mais disponibilidade)
2. Outra Availability Domain
3. Script de auto-retry (aguardar disponibilidade)
```

### Problema: Não consigo acessar porta 3000 ou 11434

**Verificar:**
```bash
# 1. Containers rodando?
docker compose ps

# 2. Firewall Oracle configurado?
# Revisar seção 3.1

# 3. Firewall Ubuntu?
sudo iptables -L -n | grep -E "11434|3000"

# 4. Reconfigurar se necessário
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 11434 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 3000 -j ACCEPT
sudo netfilter-persistent save
```

### Problema: Erro "no space left on device"

**Solução:**
```bash
# Verificar espaço
df -h

# Limpar Docker
docker system prune -a -f

# Limpar logs
sudo journalctl --vacuum-time=3d
```

### Problema: Container "unhealthy"

**Solução:**
```bash
# Ver logs
docker compose logs ollama

# Reiniciar
docker compose restart

# Se persistir, recriar
docker compose down
docker compose up -d
```

### Problema: Performance lenta

**Dicas:**
```bash
# 1. Use modelo menor
docker exec -it qwen-ollama ollama pull qwen2.5:3b

# 2. Ou versão quantizada
docker exec -it qwen-ollama ollama pull qwen2.5:7b-q4_0

# 3. Ajuste configurações no .env
nano .env
# Alterar:
# OLLAMA_NUM_PARALLEL=1
# OLLAMA_KEEP_ALIVE=2m

# Reiniciar
docker compose restart
```

---

## 9. Manutenção

### Comandos Úteis

```bash
# Ver status
./scripts/status.sh

# Ver logs
./scripts/logs.sh

# Monitorar recursos
./scripts/monitor.sh

# Backup modelos
./scripts/backup.sh

# Atualizar imagens Docker
./scripts/update.sh

# Reiniciar tudo
./scripts/restart.sh

# Parar tudo (economizar recursos)
./scripts/stop.sh

# Iniciar novamente
./scripts/start.sh
```

### Configurar Inicialização Automática

```bash
# Copiar arquivo de serviço
sudo nano /etc/systemd/system/qwen.service
```

Conteúdo:
```ini
[Unit]
Description=Qwen Local AI Server
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/ubuntu/qwen-local
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose stop
User=ubuntu
Group=docker

[Install]
WantedBy=multi-user.target
```

Ativar:
```bash
sudo systemctl daemon-reload
sudo systemctl enable qwen
sudo systemctl start qwen
```

---

## 10. Segurança (Opcional mas Recomendado)

### Habilitar Autenticação na Interface Web

```bash
# Editar .env
nano .env

# Alterar:
WEBUI_AUTH=true

# Reiniciar
docker compose restart
```

Agora a interface pedirá login/senha na primeira vez.

### Restringir Acesso por IP

Se quiser permitir apenas seu IP:

**No Oracle Cloud Security List:**
```
Source CIDR: SEU_IP/32
```

**No Ubuntu:**
```bash
# Remover regra aberta
sudo iptables -D INPUT -p tcp --dport 3000 -j ACCEPT

# Adicionar regra específica (substitua SEU_IP)
sudo iptables -A INPUT -p tcp -s SEU_IP/32 --dport 3000 -j ACCEPT
sudo iptables -A INPUT -p tcp -s SEU_IP/32 --dport 11434 -j ACCEPT

# Salvar
sudo netfilter-persistent save
```

### Configurar HTTPS (com Nginx + Let's Encrypt)

```bash
# Instalar Nginx
sudo apt install -y nginx certbot python3-certbot-nginx

# Configurar domínio (você precisa ter um domínio apontando para o IP)
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

# Obter certificado SSL
sudo certbot --nginx -d seu-dominio.com
```

---

## 11. Monitoramento de Custos

### Verificar Uso (sempre gratuito se dentro dos limites)

```bash
# No Oracle Cloud Console:
Menu → Billing & Cost Management → Cost Analysis

# Verificar se está no Free Tier:
- Compute: VM.Standard.A1.Flex (até 4 OCPUs, 24GB RAM)
- Storage: Até 200GB
- Bandwidth: Até 10TB/mês

# Se ultrapassar, você será AVISADO antes de cobrar
```

---

## 12. Recursos Adicionais

### Documentação
- [README Principal](README.md)
- [Guia Rápido](QUICK_START.md)
- [FAQ](FAQ.md)
- [Exemplos de API](examples/api-examples.md)

### Comunidade
- [GitHub Issues](https://github.com/crishpg/qwen-local/issues)
- [Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/)
- [Ollama Docs](https://github.com/ollama/ollama)

---

## 🎉 Pronto!

Você agora tem um servidor de IA **totalmente gratuito e permanente** rodando na Oracle Cloud!

**Recursos Disponíveis:**
- ✅ Interface Web: `http://SEU_IP:3000`
- ✅ API REST: `http://SEU_IP:11434`
- ✅ 24 GB RAM (suficiente para modelos grandes)
- ✅ 100 GB Storage (espaço para múltiplos modelos)
- ✅ 24/7 uptime
- ✅ **$0/mês PARA SEMPRE**

**Próximos Passos:**
1. Explore a interface web
2. Teste a API com exemplos em `examples/api-examples.md`
3. Integre com suas aplicações
4. Experimente diferentes modelos Qwen

**Divirta-se com seu servidor de IA gratuito!** 🚀🎁

---

**Criado com ❤️ para a comunidade**
