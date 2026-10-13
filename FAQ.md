# ❓ Perguntas Frequentes (FAQ)

## 🚀 Instalação e Configuração

### P: Qual o requisito mínimo de hardware?
**R:** Para rodar o Qwen confortavelmente:
- **Mínimo**: 2 vCPUs, 8GB RAM (apenas modelos 3B)
- **Recomendado**: 4 vCPUs, 16GB RAM (modelos até 14B)
- **Ideal**: 8+ vCPUs, 32GB+ RAM (modelos 32B+)

### P: Funciona sem GPU?
**R:** Sim! O Ollama funciona apenas com CPU. Uma GPU acelera significativamente, mas não é obrigatória. Para CPU, use modelos quantizados (q4_0) para melhor performance.

### P: Quanto espaço em disco preciso?
**R:** Depende dos modelos:
- **Sistema base**: ~1GB (imagens Docker)
- **Modelo 3B**: ~2GB
- **Modelo 7B**: ~4.5GB
- **Modelo 14B**: ~8GB
- **Recomendado**: Pelo menos 15-20GB livres

### P: Funciona em outras distribuições Linux além do Ubuntu?
**R:** Sim! Funciona em qualquer distribuição com Docker:
- Debian
- CentOS/RHEL
- Fedora
- Arch Linux
- Alpine Linux

Apenas ajuste os comandos de instalação do Docker para sua distro.

## 🤖 Modelos

### P: Qual modelo Qwen devo escolher?
**R:** Depende do seu hardware e necessidade:
- **qwen2.5:3b** - Rápido, pouca RAM, qualidade boa
- **qwen2.5:7b** ⭐ - Balanceado (RECOMENDADO)
- **qwen2.5:14b** - Melhor qualidade, mais lento
- **qwen2.5-coder:7b** - Especializado em código

### P: O que significa "q4_0" no nome do modelo?
**R:** É quantização - reduz precisão numérica para economizar memória:
- **q4_0**: 4-bit, ~50% menor, ligeiramente menos preciso
- **q5_0**: 5-bit, ~40% menor, melhor qualidade
- **q8_0**: 8-bit, ~20% menor, quase sem perda

### P: Posso rodar múltiplos modelos simultaneamente?
**R:** Tecnicamente sim, mas não recomendado com 16GB RAM. Cada modelo consome 2-8GB. Configure `OLLAMA_MAX_LOADED_MODELS=1` para evitar problemas.

### P: Como sei qual modelo está carregado na memória?
**R:** Execute:
```bash
./scripts/status.sh
# ou
docker exec qwen-ollama ollama ps
```

### P: Posso usar outros modelos além do Qwen?
**R:** Sim! O Ollama suporta vários modelos:
- Llama 3.2, 3.1, 3
- Mistral
- Gemma 2
- Phi-3
- CodeLlama
- E muitos outros

Lista completa: https://ollama.com/library

## 🌐 Acesso e Conectividade

### P: Como descobrir o IP do meu servidor?
**R:** Execute no servidor:
```bash
hostname -I
# ou
ip addr show | grep "inet " | grep -v 127.0.0.1
```

### P: Não consigo acessar de outro computador
**R:** Verifique:
1. Firewall está configurado? `sudo ufw status`
2. Docker está rodando? `docker ps`
3. Portas estão abertas? `sudo netstat -tulpn | grep -E ':(11434|3000)'`
4. Consegue acessar localmente? `curl localhost:11434/api/tags`

### P: É seguro expor na internet?
**R:** NÃO sem precauções:
- ✅ Use HTTPS (Nginx + Let's Encrypt)
- ✅ Habilite autenticação: `WEBUI_AUTH=true`
- ✅ Use firewall restritivo
- ✅ Configure VPN (melhor opção)
- ❌ Nunca exponha porta 11434 diretamente

### P: Como configurar HTTPS?
**R:** Use Nginx como proxy reverso:
1. Instale Nginx e Certbot
2. Configure certificado Let's Encrypt
3. Configure proxy para portas 3000 e 11434
4. Veja seção "Configurar domínio" no README.md

## 📊 Performance e Otimização

### P: As respostas estão muito lentas
**R:** Tente:
1. Usar modelo menor (3B ou 7B-q4_0)
2. Reduzir contexto: `"num_ctx": 2048`
3. Verificar CPU: `./scripts/monitor.sh`
4. Aumentar `OLLAMA_NUM_PARALLEL=1` no .env
5. Fechar outras aplicações

### P: Quanto tempo leva para gerar uma resposta?
**R:** Com 4 vCPUs:
- **qwen2.5:3b**: ~2-5 tokens/segundo
- **qwen2.5:7b**: ~1-3 tokens/segundo
- **qwen2.5:14b**: ~0.5-1.5 tokens/segundo

Uma resposta de 100 palavras (~150 tokens) leva 30s-3min dependendo do modelo.

### P: Como melhorar a qualidade das respostas?
**R:** 
1. Use modelo maior (14B ao invés de 7B)
2. Ajuste temperatura: menor = mais focado, maior = mais criativo
3. Melhore seus prompts (seja específico e claro)
4. Use exemplos no prompt (few-shot learning)

### P: O servidor está usando muita RAM
**R:**
1. Configure `OLLAMA_MAX_LOADED_MODELS=1`
2. Reduza `OLLAMA_KEEP_ALIVE=2m`
3. Use modelos quantizados (q4_0)
4. Feche modelos não usados: `docker exec qwen-ollama ollama stop <modelo>`

## 🔧 Manutenção e Backup

### P: Como fazer backup dos modelos?
**R:**
```bash
./scripts/backup.sh
```
Isso cria arquivo .tar.gz com todos os dados.

### P: Com que frequência devo fazer backup?
**R:** Recomendações:
- Após baixar novos modelos
- Semanalmente se usar em produção
- Antes de atualizações importantes

### P: Como atualizar o Ollama?
**R:**
```bash
./scripts/update.sh
```
Baixa imagens mais recentes e recria containers.

### P: Posso rodar como serviço do sistema?
**R:** Sim! Use o arquivo `qwen.service.example`:
```bash
# Editar e copiar
sudo cp qwen.service.example /etc/systemd/system/qwen.service
sudo systemctl daemon-reload
sudo systemctl enable qwen
sudo systemctl start qwen
```

## 🐛 Troubleshooting

### P: Container "qwen-ollama" está em loop de restart
**R:** Verifique logs:
```bash
./scripts/logs.sh ollama
```
Causas comuns:
- Memória insuficiente
- Modelo corrompido
- Configuração inválida no .env

### P: Erro "Cannot connect to Docker daemon"
**R:**
```bash
# Iniciar Docker
sudo systemctl start docker

# Adicionar usuário ao grupo
sudo usermod -aG docker $USER
newgrp docker
```

### P: Erro "Port already in use"
**R:** Outra aplicação está usando a porta:
```bash
# Descobrir qual processo
sudo netstat -tulpn | grep :11434

# Alterar porta no .env
nano .env
# Mudar OLLAMA_PORT para outra porta
```

### P: Modelo não responde ou trava
**R:**
1. Reinicie o container: `./scripts/restart.sh`
2. Verifique RAM disponível: `free -h`
3. Tente modelo menor
4. Verifique logs: `./scripts/logs.sh`

### P: Interface web mostra erro de conexão
**R:**
1. Verifique se Ollama está rodando: `curl localhost:11434/api/tags`
2. Reinicie serviços: `./scripts/restart.sh`
3. Verifique logs: `./scripts/logs.sh webui`

### P: Espaço em disco acabou
**R:**
```bash
# Ver uso
docker system df

# Limpar imagens antigas
docker system prune -a

# Remover modelos não usados
./scripts/models.sh list
./scripts/models.sh remove <modelo-antigo>
```

## 💻 Desenvolvimento e API

### P: Como integrar com minha aplicação?
**R:** Use a API REST na porta 11434. Veja exemplos completos em `examples/api-examples.md`

### P: A API é compatível com OpenAI?
**R:** Parcialmente. Ollama tem API similar mas não idêntica. Para compatibilidade total, use um proxy como [litellm](https://github.com/BerriAI/litellm).

### P: Como fazer streaming de respostas?
**R:** Configure `"stream": true` na requisição e processe linha por linha. Ver exemplos em `examples/api-examples.md`.

### P: Posso usar com LangChain/LlamaIndex?
**R:** Sim! Ambos têm suporte nativo para Ollama:
```python
from langchain_community.llms import Ollama
llm = Ollama(base_url="http://localhost:11434", model="qwen2.5:7b")
```

### P: Como limitar o tamanho da resposta?
**R:** Use `num_predict` nas opções:
```json
{
  "options": {
    "num_predict": 100
  }
}
```

## 🔐 Segurança

### P: Preciso de autenticação?
**R:** Depende do uso:
- **Uso local/pessoal**: Não obrigatório
- **Acesso remoto**: SIM, configure `WEBUI_AUTH=true`
- **Produção**: SIM + HTTPS + firewall restritivo

### P: Os dados são enviados para internet?
**R:** NÃO! Tudo roda localmente. Nenhum dado sai do seu servidor.

### P: É legal usar modelos Qwen comercialmente?
**R:** Sim! Qwen usa licença Apache 2.0, permitindo uso comercial. Veja detalhes em: https://huggingface.co/Qwen

## 📱 Casos de Uso

### P: Posso usar para código?
**R:** Sim! Use o modelo `qwen2.5-coder:7b` especializado em programação.

### P: Funciona em português?
**R:** Sim! Qwen tem bom suporte a português, mas inglês tem melhor qualidade.

### P: Posso processar documentos/PDFs?
**R:** A API base do Ollama processa apenas texto. Para PDFs, você precisa:
1. Extrair texto do PDF (Python: PyPDF2, pdfplumber)
2. Enviar texto extraído para o Ollama

### P: Suporta imagens?
**R:** Modelos Qwen padrão são apenas texto. Para visão, use modelos multimodais como `llava` ou `bakllava`.

## 🎓 Aprendizado

### P: Posso fazer fine-tuning dos modelos?
**R:** Não diretamente no Ollama. Para fine-tuning:
1. Use ferramentas como HuggingFace Transformers
2. Faça fine-tuning do modelo base Qwen
3. Importe modelo customizado para Ollama (via Modelfile)

### P: Onde aprender mais sobre IA/LLMs?
**R:** Recursos recomendados:
- [Ollama Documentation](https://github.com/ollama/ollama)
- [Qwen Documentation](https://huggingface.co/Qwen)
- [Prompt Engineering Guide](https://www.promptingguide.ai/)
- [LangChain Documentation](https://python.langchain.com/)

---

## 🆘 Ainda com problemas?

1. ✅ Consulte o [README.md](README.md) completo
2. ✅ Execute `./scripts/status.sh` para diagnóstico
3. ✅ Verifique logs: `./scripts/logs.sh`
4. ✅ Visite [Ollama GitHub Issues](https://github.com/ollama/ollama/issues)
5. ✅ Comunidade Qwen: [HuggingFace](https://huggingface.co/Qwen)

---

**Última atualização**: 2024
