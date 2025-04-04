#!/bin/bash

# Nome do container
CONTAINER_NAME="rasa_container"

# Verifica se o container já está rodando
if docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME\$"; then
    echo "⚡ Container já existe. Iniciando..."
    docker start $CONTAINER_NAME
else
    echo "🚀 Criando e iniciando o container..."
    docker run -d --name $CONTAINER_NAME \
        -p 5005:5005 -p 2222:22 \
        -v $(pwd):/app \
        rasa-ubuntu bash
fi

# Espera 2 segundos para garantir que o container está rodando
sleep 2

# Conecta ao container via bash
echo "🖥️ Conectando ao terminal do container..."
docker exec -it $CONTAINER_NAME bash
