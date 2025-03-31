#!/bin/bash
# Tenta pegar o texto do clipboard primário (seleção do mouse)
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
   selected_text=$(wl-paste -p 2>/dev/null)
else
   selected_text=$(xsel -p 2>/dev/null)
fi

SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Exibe o resultado
if [ -z "$selected_text" ]; then
   kdialog --msgbox "Nenhum texto selecionado ou copiado!"
else

   if [ "$selected_text" = "config" ]; then
      slider_value=$(kdialog --slider "Selecione a velocidade da fala (Normal a 3x)" 0 30 3)
      [ $? -ne 0 ] && exit 0
      speed=$(echo "scale=1; 1 - ($slider_value / 30) * (1 - 0.33)" | bc)

      echo -n "$speed" >"$SCRIPT_DIR/speed"
      exit
   fi

   speed=$(cat "$SCRIPT_DIR/speed")
   echo "$selected_text" | "$SCRIPT_DIR/piper/piper" --length-scale $speed --model "$SCRIPT_DIR/piper-voices/pt_BR-faber-medium.onnx" --output_file $SCRIPT_DIR/temp.wav >/dev/null 2>&1
   aplay $SCRIPT_DIR/temp.wav

fi