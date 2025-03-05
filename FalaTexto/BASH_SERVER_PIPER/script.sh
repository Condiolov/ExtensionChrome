#!/bin/bash
# d=""
# read d
while IFS= read -r -n1 c; do
      d="$d$c"
      if [ "$c" != '}' ]; then
            continue
      fi

      message='{"message": "ok"}'
      messagelen=${#message}
      messagelen1=$((($messagelen) & 0xFF))
      messagelen2=$((($messagelen >> 8) & 0xFF))
      messagelen3=$((($messagelen >> 16) & 0xFF))
      messagelen4=$((($messagelen >> 24) & 0xFF))

      printf "$(printf '\\x%x\\x%x\\x%x\\x%x' \
            $messagelen1 $messagelen2 $messagelen3 $messagelen4)%s" "$message"

      bash bash_server_piper.sh
      exit
      # Resposta simples: "OK"
      #    echo '{"response":"ok"}'
done