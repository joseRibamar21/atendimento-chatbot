## MODO 1
### 🚀 Passo 1: Rodar o container
```bash
docker build -t rasa_bot .
docker run -d -p 5005:5005 -p 2222:22 --name chatbot_container rasa_bot
```

### 2️⃣ Passo 2: Configurar o ssh para entrar no container pelo Remote
```bash
Host rasa-chatbot
    HostName 127.0.0.1
    User developer
    Port 2222
    IdentityFile ~/.ssh/id_rsa
```
ou apenas rodar o docker:
```bash
docker exec -it chatbot_container bash
```

## 🎓 Passo 3: Treinar o chatbot
Agora, vá para a pasta onde estão os arquivos do bot:
```bash
cd /home/developer/app/bot
```
Antes de rodar o chatbot, precisamos treinar o modelo de IA:
```bash
../venv/bin/rasa train
```

✔️ O que acontece aqui?
O Rasa vai ler os arquivos dentro da pasta bot, processar os intents e respostas, e criar um modelo de IA para o chatbot.

Se tudo der certo, ele vai gerar um arquivo dentro da pasta:
```bash
models/
 ├── 20240404-123456.tar.gz
```
Esse arquivo é o modelo treinado, pronto para ser usado pelo chatbot.

## 💬 Passo 4: Testar o chatbot no terminal
Agora podemos conversar com o chatbot diretamente no terminal:
```sh
../venv/bin/rasa shell
```
Isso inicia o bot e você pode digitar mensagens como:
```css
Olá
```

## 🌐 Passo 5: Testar via API
Se quisermos testar o chatbot via API REST, podemos rodá-lo com:
```sh
../venv/bin/rasa run --enable-api --cors "*" -p 5050
```

para evitar conflitos com a porta do Docker que já esta rodando o projeto, coloque uma outra porta livre, no caso a 5050

Agora, podemos enviar uma mensagem para o chatbot via cURL:
```sh
curl -X POST "http://localhost:5050/webhooks/rest/webhook" \
     -H "Content-Type: application/json" \
     -d '{"sender": "user", "message": "Olá"}'
```