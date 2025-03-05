#!/bin/bash
# echo $0
PORT=21116

#echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n"

post_mp3_html() {

    REQUEST_HEADER=""
    while IFS= read -r line; do
        # Adiciona cada linha ao conteúdo do cabeçalho
        REQUEST_HEADER+="$line"$'\n'
        # Verifica se a linha está vazia (fim do cabeçalho HTTP)
        if [[ "$line" == $'\r' || -z "$line" ]]; then
            break
        fi
    done
    # echo $REQUEST_HEADER

    CONTENT_LENGTH=$(echo "$REQUEST_HEADER" | grep -i 'Content-Length:' | awk '{print $2}')
    CONTENT_LENGTH=${CONTENT_LENGTH//$'\r'/} # Remove o \r (retorno de carro)
    #     CONTENT_HOST=$(echo "$REQUEST_HEADER" | grep -i 'Host:' | awk '{print $2}')
    CONTENT_HOST=$(echo "$REQUEST_HEADER" | grep -i 'Origin:' | awk '{print $2}')

    echo $REQUEST_HEADER >file.txt
    CONTENT_HOST=${CONTENT_HOST//$'\r'/} # Remove o \r (retorno de carro)
    REQUISICAO=$(echo "$REQUEST_HEADER" | grep -i 'GET' | awk '{print $2}')

    #     echo "$REQUEST_HEADER"
    [[ "$REQUISICAO" =~ \.mp3 ]] &&
        {
            echo -e "HTTP/1.1 200 OK\r\nContent-Type: audio/mpeg\r\n\r\n"
            cat "$PWD$REQUISICAO"
        } && exit

    #     echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n"
    [[ "$REQUISICAO" == '/' ]] && REQUISICAO='/index.html'

    #     echo $REQUISICAO

    [[ "$REQUISICAO" =~ \.html ]] &&
        {
            echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\n\r\n"
            [[ -f "$PWD$REQUISICAO" ]] && cat "$PWD$REQUISICAO" || echo "⚠️ Pagina não existe!! "
        } && exit

    if [[ "$REQUEST_HEADER" == *"POST"* && "$CONTENT_LENGTH" -gt 0 ]]; then

        REQUEST_BODY=$(dd bs=1 count="$CONTENT_LENGTH" 2>/dev/null)
        TEXTO=$(echo "$REQUEST_BODY" | jq -r '.texto')
        VELOCIDADE=$(echo "$REQUEST_BODY" | jq -r '.velocidade')

        [[ $VELOCIDADE != "null" ]] && echo $VELOCIDADE >speed
    fi

    [[ -n "$TEXTO" ]] && {
        echo "$TEXTO" | "$PWD/piper/piper" --model "$PWD/piper-voices/pt_BR-faber-medium.onnx" --output_file ./temp.wav >/dev/null 2>&1

        nome_audio=$(md5sum temp.wav | awk '{print $1}')
        rm *.mp3

        VELOCIDADE=$(cat speed)
        ffmpeg -i temp.wav -filter:a "atempo=$VELOCIDADE" "$nome_audio.mp3" -y >/dev/null 2>&1
        rm temp.wav

        JSON='[{"url":"'"$CONTENT_HOST"'/'"$nome_audio"'.mp3"}]'

        echo "HTTP/1.1 200 OK"
        echo -e "Content-Type: application/json\r"
        echo -e "Content-Length: ${#JSON}\r"
        echo -e "Access-Control-Allow-Origin: *\r" # Permite qualquer origem
        # 	echo "Connection: close"
        echo         # Linha em branco para separar cabeçalhos do corpo
        echo "$JSON" # Corpo da resposta
    }

}

[[ -n "$1" ]] && $1 && exit

pgrep -f "ncat -l -p $PORT" >/dev/null 2>&1 && exit

while true; do
    ncat -l -p $PORT -e "$0 post_mp3_html"
done
