#!/bin/bash
# Lê a requisição HTTP recebida via stdin
# Lê o cabeçalho da requisição HTTP
REQUEST_HEADER=""
while IFS= read -r line; do
   # Adiciona cada linha ao conteúdo do cabeçalho
   REQUEST_HEADER+="$line"$'\n'
   # Verifica se a linha está vazia (fim do cabeçalho HTTP)
   if [[ "$line" == $'\r' || -z "$line" ]]; then
      break
   fi
done

# Exibe o cabeçalho da requisição (para depuração)
# echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n"
# echo "Cabeçalho da requisição:"
# echo "$REQUEST_HEADER"
# echo "-------------------"

# Verifica se é uma requisição POST e obtém o tamanho do corpo
CONTENT_LENGTH=$(echo "$REQUEST_HEADER" | grep -i 'Content-Length:' | awk '{print $2}')
CONTENT_LENGTH=${CONTENT_LENGTH//$'\r'/} # Remove o \r (retorno de carro)

# Se for uma requisição POST, lê o corpo
if [[ "$REQUEST_HEADER" == *"POST"* && -n "$CONTENT_LENGTH" && "$CONTENT_LENGTH" -gt 0 ]]; then
   #    echo "Lendo corpo da requisição POST (tamanho: $CONTENT_LENGTH bytes)..."
   read -r -n "$CONTENT_LENGTH" REQUEST_BODY
#    echo "JSON: $REQUEST_BODY"

fi

# Envia o cabeçalho HTTP
# echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n"

# Resposta simples
# echo "Requisição recebida com sucesso!"

# Exibe a requisição recebida (para depuração)
# echo "Requisição recebida:"
# echo "$REQUEST"
# echo "-------------------"

# Envia o cabeçalho HTTP
echo -e "HTTP/1.1 200 OK\r\nContent-Type: audio/mpeg\r\n\r\n"
cat "audio.mp3"

# echo -e "HTTP/1.1 200 OK
# Content-Type: text/html
#
# <html><body><h1>Hello $REQUEST World</h1></body></html>"

# echo -e "HTTP/1.1 200 OK\r\nContent-Type: audio/mpeg\r\n\r\n"
# cat "audio.mp3"