# 🔌 Exemplos de Uso da API Ollama

Este arquivo contém exemplos práticos de como consumir a API do Ollama em diferentes linguagens de programação.

## 📡 Endpoints Disponíveis

Base URL: `http://SEU_IP_SERVIDOR:11434`

- `POST /api/generate` - Gerar texto (completion)
- `POST /api/chat` - Chat interativo
- `GET /api/tags` - Listar modelos instalados
- `POST /api/pull` - Baixar modelo
- `POST /api/show` - Informações do modelo
- `DELETE /api/delete` - Remover modelo

## 🐍 Python

### Exemplo Básico com Requests

```python
import requests
import json

# Configuração
BASE_URL = "http://localhost:11434"
MODEL = "qwen2.5:7b"

def generate_text(prompt):
    """Gera texto a partir de um prompt"""
    url = f"{BASE_URL}/api/generate"
    
    payload = {
        "model": MODEL,
        "prompt": prompt,
        "stream": False
    }
    
    response = requests.post(url, json=payload)
    result = response.json()
    
    return result['response']

def chat(messages):
    """Chat interativo com histórico"""
    url = f"{BASE_URL}/api/chat"
    
    payload = {
        "model": MODEL,
        "messages": messages,
        "stream": False
    }
    
    response = requests.post(url, json=payload)
    result = response.json()
    
    return result['message']['content']

# Exemplos de uso
if __name__ == "__main__":
    # Exemplo 1: Geração de texto simples
    print("=== Geração de Texto ===")
    resposta = generate_text("Explique o que é Docker em uma frase.")
    print(resposta)
    print()
    
    # Exemplo 2: Chat com histórico
    print("=== Chat com Histórico ===")
    historico = [
        {"role": "user", "content": "Olá! Qual é o seu nome?"},
    ]
    resposta1 = chat(historico)
    print(f"Assistente: {resposta1}")
    
    # Adicionar resposta ao histórico e continuar
    historico.append({"role": "assistant", "content": resposta1})
    historico.append({"role": "user", "content": "Você pode me ajudar com programação?"})
    
    resposta2 = chat(historico)
    print(f"Assistente: {resposta2}")
```

### Exemplo com Streaming

```python
import requests
import json

def generate_stream(prompt):
    """Gera texto com streaming (palavra por palavra)"""
    url = "http://localhost:11434/api/generate"
    
    payload = {
        "model": "qwen2.5:7b",
        "prompt": prompt,
        "stream": True
    }
    
    response = requests.post(url, json=payload, stream=True)
    
    print("Resposta: ", end="", flush=True)
    for line in response.iter_lines():
        if line:
            data = json.loads(line)
            token = data.get('response', '')
            print(token, end="", flush=True)
            
            if data.get('done', False):
                print("\n")
                break

# Uso
generate_stream("Escreva um poema curto sobre IA")
```

### Exemplo com Parâmetros Avançados

```python
import requests

def generate_advanced(prompt, temperature=0.7, top_p=0.9, max_tokens=500):
    """Geração com controle de parâmetros"""
    url = "http://localhost:11434/api/generate"
    
    payload = {
        "model": "qwen2.5:7b",
        "prompt": prompt,
        "stream": False,
        "options": {
            "temperature": temperature,
            "top_p": top_p,
            "num_predict": max_tokens,
        }
    }
    
    response = requests.post(url, json=payload)
    return response.json()['response']

# Mais criativo (temperature alta)
print(generate_advanced("Invente uma história", temperature=0.9))

# Mais determinístico (temperature baixa)
print(generate_advanced("Qual é 2+2?", temperature=0.1))
```

## 🟨 JavaScript/Node.js

### Exemplo Básico com Fetch

```javascript
// Requer Node.js 18+ ou usar node-fetch para versões anteriores

const BASE_URL = 'http://localhost:11434';
const MODEL = 'qwen2.5:7b';

async function generateText(prompt) {
    const response = await fetch(`${BASE_URL}/api/generate`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            model: MODEL,
            prompt: prompt,
            stream: false
        })
    });
    
    const data = await response.json();
    return data.response;
}

async function chat(messages) {
    const response = await fetch(`${BASE_URL}/api/chat`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            model: MODEL,
            messages: messages,
            stream: false
        })
    });
    
    const data = await response.json();
    return data.message.content;
}

// Uso
(async () => {
    // Exemplo 1: Geração simples
    const resposta = await generateText('Explique JavaScript em uma frase');
    console.log(resposta);
    
    // Exemplo 2: Chat
    const historico = [
        { role: 'user', content: 'Olá! Como você está?' }
    ];
    const respostaChat = await chat(historico);
    console.log(respostaChat);
})();
```

### Exemplo com Axios

```javascript
const axios = require('axios');

const api = axios.create({
    baseURL: 'http://localhost:11434/api',
    headers: {
        'Content-Type': 'application/json'
    }
});

async function generateText(prompt) {
    try {
        const response = await api.post('/generate', {
            model: 'qwen2.5:7b',
            prompt: prompt,
            stream: false
        });
        return response.data.response;
    } catch (error) {
        console.error('Erro:', error.message);
        throw error;
    }
}

async function listModels() {
    try {
        const response = await api.get('/tags');
        return response.data.models;
    } catch (error) {
        console.error('Erro:', error.message);
        throw error;
    }
}

// Uso
(async () => {
    const modelos = await listModels();
    console.log('Modelos disponíveis:', modelos.map(m => m.name));
    
    const resposta = await generateText('O que é Node.js?');
    console.log('Resposta:', resposta);
})();
```

## 🐚 cURL (Shell/Bash)

### Geração de Texto

```bash
curl http://localhost:11434/api/generate -d '{
  "model": "qwen2.5:7b",
  "prompt": "Explique Docker em uma frase",
  "stream": false
}'
```

### Chat Interativo

```bash
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
```

### Listar Modelos

```bash
curl http://localhost:11434/api/tags | jq '.models[] | .name'
```

### Com Parâmetros Customizados

```bash
curl http://localhost:11434/api/generate -d '{
  "model": "qwen2.5:7b",
  "prompt": "Escreva um haiku sobre programação",
  "stream": false,
  "options": {
    "temperature": 0.8,
    "top_p": 0.9,
    "num_predict": 100
  }
}'
```

## 🦀 Rust

```rust
use reqwest;
use serde::{Deserialize, Serialize};

#[derive(Serialize)]
struct GenerateRequest {
    model: String,
    prompt: String,
    stream: bool,
}

#[derive(Deserialize)]
struct GenerateResponse {
    response: String,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::Client::new();
    
    let request = GenerateRequest {
        model: "qwen2.5:7b".to_string(),
        prompt: "Explique Rust em uma frase".to_string(),
        stream: false,
    };
    
    let response = client
        .post("http://localhost:11434/api/generate")
        .json(&request)
        .send()
        .await?
        .json::<GenerateResponse>()
        .await?;
    
    println!("Resposta: {}", response.response);
    
    Ok(())
}
```

## 🐹 Go

```go
package main

import (
    "bytes"
    "encoding/json"
    "fmt"
    "io"
    "net/http"
)

type GenerateRequest struct {
    Model  string `json:"model"`
    Prompt string `json:"prompt"`
    Stream bool   `json:"stream"`
}

type GenerateResponse struct {
    Response string `json:"response"`
}

func generateText(prompt string) (string, error) {
    url := "http://localhost:11434/api/generate"
    
    reqBody := GenerateRequest{
        Model:  "qwen2.5:7b",
        Prompt: prompt,
        Stream: false,
    }
    
    jsonData, err := json.Marshal(reqBody)
    if err != nil {
        return "", err
    }
    
    resp, err := http.Post(url, "application/json", bytes.NewBuffer(jsonData))
    if err != nil {
        return "", err
    }
    defer resp.Body.Close()
    
    body, err := io.ReadAll(resp.Body)
    if err != nil {
        return "", err
    }
    
    var result GenerateResponse
    err = json.Unmarshal(body, &result)
    if err != nil {
        return "", err
    }
    
    return result.Response, nil
}

func main() {
    resposta, err := generateText("Explique Go em uma frase")
    if err != nil {
        fmt.Println("Erro:", err)
        return
    }
    
    fmt.Println("Resposta:", resposta)
}
```

## ☕ Java

```java
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

public class OllamaClient {
    private static final String BASE_URL = "http://localhost:11434";
    private static final HttpClient client = HttpClient.newHttpClient();
    private static final Gson gson = new Gson();
    
    public static String generateText(String prompt) throws Exception {
        JsonObject request = new JsonObject();
        request.addProperty("model", "qwen2.5:7b");
        request.addProperty("prompt", prompt);
        request.addProperty("stream", false);
        
        HttpRequest httpRequest = HttpRequest.newBuilder()
            .uri(URI.create(BASE_URL + "/api/generate"))
            .header("Content-Type", "application/json")
            .POST(HttpRequest.BodyPublishers.ofString(gson.toJson(request)))
            .build();
        
        HttpResponse<String> response = client.send(httpRequest, 
            HttpResponse.BodyHandlers.ofString());
        
        JsonObject jsonResponse = gson.fromJson(response.body(), JsonObject.class);
        return jsonResponse.get("response").getAsString();
    }
    
    public static void main(String[] args) {
        try {
            String resposta = generateText("Explique Java em uma frase");
            System.out.println("Resposta: " + resposta);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

## 🔧 Parâmetros da API

### Opções Disponíveis

```json
{
  "temperature": 0.7,      // Criatividade (0.0 - 2.0)
  "top_p": 0.9,           // Nucleus sampling
  "top_k": 40,            // Top-k sampling
  "num_predict": 500,     // Máximo de tokens
  "repeat_penalty": 1.1,  // Penalidade para repetição
  "seed": 42,             // Seed para reprodutibilidade
  "num_ctx": 2048,        // Tamanho do contexto
  "stop": [".", "!"]      // Tokens de parada
}
```

### Exemplo com Todas as Opções

```python
import requests

payload = {
    "model": "qwen2.5:7b",
    "prompt": "Escreva uma história curta sobre robôs",
    "stream": False,
    "options": {
        "temperature": 0.8,
        "top_p": 0.9,
        "top_k": 40,
        "num_predict": 200,
        "repeat_penalty": 1.2,
        "seed": 42,
        "num_ctx": 2048
    }
}

response = requests.post("http://localhost:11434/api/generate", json=payload)
print(response.json()['response'])
```

## 🎯 Casos de Uso

### 1. Análise de Sentimento

```python
def analisar_sentimento(texto):
    prompt = f"""Analise o sentimento do seguinte texto e responda apenas com: POSITIVO, NEGATIVO ou NEUTRO.

Texto: {texto}

Sentimento:"""
    
    resposta = generate_text(prompt)
    return resposta.strip()

# Uso
print(analisar_sentimento("Adorei este produto! Funciona perfeitamente."))
```

### 2. Resumo de Texto

```python
def resumir_texto(texto, max_palavras=50):
    prompt = f"""Resuma o seguinte texto em no máximo {max_palavras} palavras:

{texto}

Resumo:"""
    
    return generate_text(prompt)
```

### 3. Geração de Código

```python
def gerar_codigo(linguagem, descricao):
    prompt = f"""Escreva código em {linguagem} para: {descricao}

Apenas o código, sem explicações adicionais."""
    
    return generate_text(prompt)

# Uso
codigo = gerar_codigo("Python", "função que calcula fibonacci")
print(codigo)
```

### 4. Tradução

```python
def traduzir(texto, idioma_origem, idioma_destino):
    prompt = f"""Traduza o seguinte texto de {idioma_origem} para {idioma_destino}:

{texto}

Tradução:"""
    
    return generate_text(prompt)
```

## 📚 Recursos Adicionais

- [Documentação Oficial da API Ollama](https://github.com/ollama/ollama/blob/main/docs/api.md)
- [Modelos Qwen](https://huggingface.co/Qwen)
- [Melhores Práticas de Prompting](https://www.promptingguide.ai/)

---

**Dica**: Para melhor performance, use modelos quantizados (q4_0, q5_0) em hardware limitado!
