#!/bin/bash
#---------------------------------------------------------------
# Script : 0_instala_FalaTexto.sh
# Versão : 1.0 (/home/thiago/Documents/_Projetos/KDE/UTEIS/FalaTexto/0_instala_FalaTexto.sh)
# Autor  : Thiago Condé - @condiolov @diversalizando
# Data   : 31-03-2025 19:39:02
# Info   : Não testei no Xorg, apenas no Wayland cuja a lib que pega o texto selecionado precisa ser intalada!
# Requis.: bash 0_instala_FalaTexto.sh
#---------------------------------------------------------------

sudo apt install wl-clipboard
chmod +x FalaTexto.sh

systemsettings kcm_keys