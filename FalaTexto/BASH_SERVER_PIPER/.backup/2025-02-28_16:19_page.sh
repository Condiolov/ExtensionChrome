#!/bin/bash

# echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n"

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

# echo "$PWD"

REQUISICAO=$(echo "$REQUEST_HEADER" | grep -i 'GET' | awk '{print $2}')
# echo "$REQUISICAO"
echo "imprimir" >&2
[[ "$REQUISICAO" =~ \.mp3 ]] &&
	{
		echo -e "HTTP/1.1 200 OK\r\nContent-Type: audio/mpeg\r\n\r\n"
		cat "$PWD$REQUISICAO"
		#       echo "$PWD$REQUISICAO" >&2
	} && exit
	#echo $CONTENT_LENGTH >&2
	echo "nao imprimir" >&2
	# Se for uma requisição POST, lê o corpo
	if [[ "$REQUEST_HEADER" == *"POST"* && -n "$CONTENT_LENGTH" && "$CONTENT_LENGTH" -gt 0 ]]; then
		#    echo "Lendo corpo da requisição POST (tamanho: $CONTENT_LENGTH bytes)..."
		#    read -r -n "$CONTENT_LENGTH" -t 10 REQUEST_BODY
		REQUEST_BODY=$(dd bs=1 count="$CONTENT_LENGTH" 2>/dev/null)
		#    REQUEST_BODY=$(dd bs=1 count=$CONTENT_LENGTH 2>/dev/null)

   #    echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/json\r\n\r\n"
   #    echo "JSON: $REQUEST_BODY"

   TEXTO=$(echo "$REQUEST_BODY" | jq -r '.texto')
   #    echo "TEXTO: $TEXTO"

	fi


[[ -n "$TEXTO" ]] && {
	echo "$TEXTO" | '/home/thiago/Documents/_Projetos/TTS/PIPER TTS SERVER/piper/piper' --model '/home/thiago/Documents/_Projetos/TTS/PIPER TTS SERVER/piper-voices/pt_BR-faber-medium.onnx' --output_file ./temp.wav >&2
	ffmpeg -i temp.wav temp.mp3 -y
	rm temp.wav

	echo -e "HTTP/1.1 200 OK\r"
	echo -e "Content-Type: audio/mpeg\r"
	echo -e "Access-Control-Allow-Origin: *\r"
	echo -e "\r"
	cat "temp.mp3"
}
