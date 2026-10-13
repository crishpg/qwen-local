# 📚 Exemplos de Uso

Esta pasta contém exemplos práticos de como usar o servidor Qwen em diferentes cenários.

## 📁 Conteúdo

- **[api-examples.md](api-examples.md)** - Exemplos de integração em múltiplas linguagens (Python, JavaScript, Go, Rust, Java)

## 🚀 Como Usar os Exemplos

### Pré-requisitos

1. Servidor Qwen rodando:
```bash
./scripts/start.sh
```

2. Modelo baixado:
```bash
./scripts/models.sh pull qwen2.5:7b
```

3. Verificar que está funcionando:
```bash
./scripts/status.sh
```

### Testar Conexão Básica

```bash
# Via curl
curl http://localhost:11434/api/tags

# Via script
./scripts/test-api.sh
```

## 💡 Casos de Uso Práticos

### 1. Chatbot Simples

Crie um chatbot interativo que mantém contexto da conversa.

**Arquivo**: `chatbot.py`
```python
import requests

class QwenChatbot:
    def __init__(self, base_url="http://localhost:11434", model="qwen2.5:7b"):
        self.base_url = base_url
        self.model = model
        self.history = []
    
    def chat(self, user_message):
        self.history.append({"role": "user", "content": user_message})
        
        response = requests.post(f"{self.base_url}/api/chat", json={
            "model": self.model,
            "messages": self.history,
            "stream": False
        })
        
        assistant_message = response.json()['message']['content']
        self.history.append({"role": "assistant", "content": assistant_message})
        
        return assistant_message

# Uso
bot = QwenChatbot()
print(bot.chat("Olá! Qual o seu nome?"))
print(bot.chat("Pode me ajudar com programação?"))
```

### 2. Análise de Sentimento em Batch

Analise sentimento de múltiplos textos.

**Arquivo**: `sentiment_analyzer.py`
```python
import requests
from concurrent.futures import ThreadPoolExecutor

def analyze_sentiment(text):
    response = requests.post("http://localhost:11434/api/generate", json={
        "model": "qwen2.5:7b",
        "prompt": f"Analise o sentimento (POSITIVO/NEGATIVO/NEUTRO): {text}\nSentimento:",
        "stream": False
    })
    return response.json()['response'].strip()

# Análise em paralelo
textos = [
    "Adorei este produto!",
    "Péssima experiência, não recomendo.",
    "É ok, nada demais.",
]

with ThreadPoolExecutor(max_workers=2) as executor:
    resultados = list(executor.map(analyze_sentiment, textos))

for texto, sentimento in zip(textos, resultados):
    print(f"{texto} → {sentimento}")
```

### 3. Gerador de Conteúdo para Blog

Gere artigos de blog automaticamente.

**Arquivo**: `blog_generator.py`
```python
import requests

def gerar_artigo(topico, palavras_chave, tamanho="médio"):
    tamanhos = {"curto": 200, "médio": 500, "longo": 1000}
    max_tokens = tamanhos.get(tamanho, 500)
    
    prompt = f"""Escreva um artigo de blog sobre: {topico}

Palavras-chave a incluir: {', '.join(palavras_chave)}

Estrutura:
1. Introdução chamativa
2. Desenvolvimento com exemplos
3. Conclusão

Artigo:"""
    
    response = requests.post("http://localhost:11434/api/generate", json={
        "model": "qwen2.5:7b",
        "prompt": prompt,
        "stream": False,
        "options": {
            "num_predict": max_tokens,
            "temperature": 0.8
        }
    })
    
    return response.json()['response']

# Uso
artigo = gerar_artigo(
    topico="Inteligência Artificial na Saúde",
    palavras_chave=["diagnóstico", "machine learning", "telemedicina"],
    tamanho="médio"
)
print(artigo)
```

### 4. Assistente de Código

Sistema de perguntas e respostas sobre código.

**Arquivo**: `code_assistant.py`
```python
import requests

class CodeAssistant:
    def __init__(self):
        self.model = "qwen2.5-coder:7b"
        self.base_url = "http://localhost:11434"
    
    def explain_code(self, code, language="python"):
        prompt = f"""Explique o seguinte código {language}:

```{language}
{code}
```

Explicação detalhada:"""
        
        return self._query(prompt)
    
    def find_bugs(self, code, language="python"):
        prompt = f"""Analise este código {language} e identifique bugs:

```{language}
{code}
```

Bugs encontrados:"""
        
        return self._query(prompt)
    
    def improve_code(self, code, language="python"):
        prompt = f"""Melhore este código {language}:

```{language}
{code}
```

Código melhorado:"""
        
        return self._query(prompt)
    
    def _query(self, prompt):
        response = requests.post(f"{self.base_url}/api/generate", json={
            "model": self.model,
            "prompt": prompt,
            "stream": False
        })
        return response.json()['response']

# Uso
assistant = CodeAssistant()

codigo = """
def calcular_media(numeros):
    total = 0
    for n in numeros:
        total = total + n
    return total / len(numeros)
"""

print(assistant.explain_code(codigo))
print(assistant.improve_code(codigo))
```

### 5. Tradutor de Documentos

Traduza documentos mantendo formatação.

**Arquivo**: `translator.py`
```python
import requests

def traduzir_documento(texto, idioma_origem="inglês", idioma_destino="português"):
    # Dividir em parágrafos para não exceder limites
    paragrafos = texto.split('\n\n')
    traducoes = []
    
    for paragrafo in paragrafos:
        if not paragrafo.strip():
            traducoes.append('')
            continue
            
        prompt = f"""Traduza de {idioma_origem} para {idioma_destino}:

{paragrafo}

Tradução:"""
        
        response = requests.post("http://localhost:11434/api/generate", json={
            "model": "qwen2.5:7b",
            "prompt": prompt,
            "stream": False,
            "options": {
                "temperature": 0.3  # Baixa para tradução mais literal
            }
        })
        
        traducoes.append(response.json()['response'])
    
    return '\n\n'.join(traducoes)

# Uso
documento = """Artificial Intelligence is transforming industries.

Companies are investing heavily in AI research.

The future looks promising."""

print(traduzir_documento(documento))
```

## 🎯 Dicas de Uso

### 1. Otimização de Performance

```python
# Use streaming para respostas longas
response = requests.post(url, json={...}, stream=True)
for line in response.iter_lines():
    # Processar linha por linha
    pass
```

### 2. Tratamento de Erros

```python
import requests
from requests.exceptions import RequestException

try:
    response = requests.post(url, json=payload, timeout=30)
    response.raise_for_status()
except RequestException as e:
    print(f"Erro na API: {e}")
```

### 3. Pool de Conexões

```python
import requests

# Reutilizar conexões
session = requests.Session()
session.post(url, json=payload)
```

### 4. Configuração de Temperatura

```python
# Temperatura baixa (0.1-0.3): Respostas mais focadas/determinísticas
# Temperatura média (0.5-0.7): Balanceado
# Temperatura alta (0.8-1.0): Mais criativo/aleatório

options = {"temperature": 0.7}
```

## 🔗 Recursos Adicionais

- **[Documentação da API Ollama](https://github.com/ollama/ollama/blob/main/docs/api.md)**
- **[Guia de Prompting](https://www.promptingguide.ai/)**
- **[Exemplos Avançados](api-examples.md)**

## 💬 Contribuindo

Tem um exemplo interessante? Contribua!

1. Crie seu exemplo
2. Documente bem o código
3. Adicione ao repositório
4. Compartilhe com a comunidade

---

**Explore, experimente e divirta-se! 🚀**
