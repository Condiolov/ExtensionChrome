#!/bin/bash

REQUEST_HEADER=""
while IFS= read -r line; do
   # Adiciona cada linha ao conteúdo do cabeçalho
   REQUEST_HEADER+="$line"$'\n'
   # Verifica se a linha está vazia (fim do cabeçalho HTTP)
   if [[ "$line" == $'\r' || -z "$line" ]]; then
      break
   fi
done
# Verifica se é uma requisição POST e obtém o tamanho do corpo
CONTENT_LENGTH=$(echo "$REQUEST_HEADER" | grep -i 'Content-Length:' | awk '{print $2}')
CONTENT_LENGTH=${CONTENT_LENGTH//$'\r'/} # Remove o \r (retorno de carro)

# echo $CONTENT_LENGTH >&2

# Se for uma requisição POST, lê o corpo
if [[ "$REQUEST_HEADER" == *"POST"* && -n "$CONTENT_LENGTH" && "$CONTENT_LENGTH" -gt 0 ]]; then
   #    echo "Lendo corpo da requisição POST (tamanho: $CONTENT_LENGTH bytes)..."
   #    read -r -n "$CONTENT_LENGTH" -t 10 REQUEST_BODY
   REQUEST_BODY=$(dd bs=1 count="$CONTENT_LENGTH" 2>/dev/null)
   #    REQUEST_BODY=$(dd bs=1 count=$CONTENT_LENGTH 2>/dev/null)

   echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/json\r\n\r\n"
   echo "JSON: $REQUEST_BODY"

   TEXTO=$(echo "$REQUEST_BODY" | jq -r '.texto')
   echo "TEXTO: $TEXTO"

fi

# AUDIO
# echo -e "HTTP/1.1 200 OK\r\nContent-Type: audio/mpeg\r\n\r\n"
# cat "audio.mp3"

# echo -e "HTTP/1.1 200 OK
# Content-Type: text/html
#
# <html><body><h1>Hello $REQUEST World</h1></body></html>"

# echo -e "HTTP/1.1 200 OK\r\nContent-Type: audio/mpeg\r\n\r\n"
# cat "audio.mp3"