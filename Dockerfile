# Usar Ubuntu como base
FROM ubuntu:22.04 

# Definir o ambiente como não interativo
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências essenciais
RUN apt-get update && apt-get install -y \
    python3.10 python3.10-venv python3.10-dev python3-pip \
    inotify-tools curl git nano openssh-server && \
    apt-get clean

# Criar usuário para acesso SSH
RUN useradd -m -s /bin/bash developer && echo "developer:password" | chpasswd

# Criar diretório do projeto dentro do home do usuário
WORKDIR /home/developer/app

# Garantir que o usuário developer tem permissão para modificar
RUN chown -R developer:developer /home/developer/app

# Criar e ativar o ambiente virtual
RUN python3 -m venv venv

# Copiar os requisitos do projeto
COPY requirements.txt .

# Atualizar pip e instalar dependências
RUN venv/bin/pip install --upgrade pip && venv/bin/pip install -r requirements.txt

# Instalar Rasa
RUN venv/bin/pip install rasa

# Copiar todos os arquivos do chatbot (pasta `bot`) para dentro do container
COPY bot/ /home/developer/app/bot/

# Ajustar permissões da pasta bot
RUN chown -R developer:developer /home/developer/app/bot

# Criar diretório para SSH
RUN mkdir /var/run/sshd

# Permitir conexões SSH por senha (não recomendado em produção)
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Expor portas para SSH e Rasa
EXPOSE 5005 2222

# Iniciar SSH e rodar Rasa com hot reload
CMD service ssh start && \
    venv/bin/rasa run --enable-api --cors "*" & \
    while inotifywait -r -e modify /home/developer/app/bot; do \
        echo "Reiniciando Rasa..."; \
        pkill -f 'rasa run' && venv/bin/rasa run --enable-api --cors "*"; \
    done
