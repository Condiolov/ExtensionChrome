FalaTexto - Extensão para Chrome|Brave 🎙️

Ícone da Extensão: icon.png

FalaTexto é uma extensão para o Google Chrome | Brave que transforma texto selecionado em páginas web em áudio. Controle a velocidade, baixe o arquivo MP3 e ouça seus textos favoritos com facilidade! 🚀

Funcionalidades
- Converta texto em áudio: Selecione texto e ouça instantaneamente.
- Controle de velocidade: Escolha entre 1x, 1.5x, 2x, 2.5x e 3x.
- Download de áudio: Salve como MP3 com um clique.
- Play/Pause: Controle a reprodução diretamente no popup.
- Persistência: A velocidade escolhida é salva para uso futuro.

Requisitos
- Chrome|Brave: Versão atualizada.
- Servidor local: Minimal server bash com ncat pasta: BASH_SERVER_PIPER
- FFmpeg: Necessário no servidor para conversão de áudio.

Instalação

1. Clonar o Repositório
git clone https://github.com/Condiolov/ExtensionChrome.git
cd ExtensionChrome/FalaTexto

2. Carregar no Chrome
1. Abra chrome://extensions/.
2. Ative o Modo Desenvolvedor (canto superior direito).
3. Clique em Carregar sem compactação e selecione a pasta FalaTexto.

3. Configurar o Servidor Local
execute o ./BASH_SERVER_PIPER/script.sh
A extensão requer um servidor em http://localhost:21116. Veja se funciona!


Dependências do Servidor
1. Instale:
   - ffmpeg: sudo apt install ffmpeg
   - netcat (nc): sudo apt install netcat
   - jq: sudo apt install jq
2. Execute: bash ./BASH_SERVER_PIPER/script.sh

Como Usar
1. Clique no ícone da extensão na barra do Chrome.
2. Selecione um texto na página.
3. O áudio será gerado automaticamente no popup.
4. Controles:
   - 🔃: Regerar áudio.
   - ▶️/⏸️: Play/Pause.
   - 💾: Baixar como MP3.
   - Velocidade: Clique em "Velocidade: Nx" para alternar.

Estrutura do Projeto
FalaTexto/
├── background.js       # Script de background
├── icon.png            # Ícone (48x48 e 128x128)
├── manifest.json       # Configuração da extensão
├── popup.html          # Interface do popup
└── popup.js            # Lógica do popup

Notas Técnicas
- Usa localStorage para salvar a velocidade.
- Comunicação com o servidor via postMessage.
- O servidor deve retornar: [{"url": "URL_DO_AUDIO"}].

Contribuição
1. Faça um fork do repositório.
2. Crie uma branch: git checkout -b minha-feature
3. Commit: git commit -m 'Adiciona feature X'
4. Push: git push origin minha-feature
5. Abra um Pull Request.

Licença
Licenciado sob a MIT License.

Autor
- Condiolov - https://github.com/Condiolov

Dica: Reporte bugs ou sugira melhorias na aba Issues!