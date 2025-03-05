# 🎙️ FalaTexto - Extensão para Chrome | Brave

Transforme texto selecionado em páginas web em áudio com facilidade!
Controle a velocidade, baixe o MP3 e ouça seus textos favoritos onde quiser. 🚀

---

## 🛠️ Funcionalidades
✅ **Conversão de Texto em Áudio** - Selecione qualquer texto e ouça instantaneamente.  
✅ **Controle de Velocidade** - Escolha entre **1x, 1.5x, 2x, 2.5x e 3x**.  
✅ **Download de Áudio** - Salve como **MP3** com um clique.  
✅ **Play/Pause** - Controle a reprodução diretamente no popup.  
✅ **Persistência** - A velocidade escolhida fica salva para uso futuro.  

---

## 📌 Requisitos
🔹 **Navegador**: Chrome ou Brave (versão atualizada).  
🔹 **Servidor Local**: Requer **BASH_SERVER_PIPER** (mínimo com **ncat**).  
🔹 **FFmpeg**: Necessário para conversão de áudio.  

---

## 📥 Instalação

### 🔹 1. Clonar o Repositório
```bash
git clone https://github.com/Condiolov/ExtensionChrome.git
cd ExtensionChrome/FalaTexto
```

### 🔹 2. Carregar no Chrome
1. Abra `chrome://extensions/`.
2. Ative o **Modo Desenvolvedor** (canto superior direito).
3. Clique em **Carregar sem compactação** e selecione a pasta `FalaTexto`.

### 🔹 3. Configurar o Servidor Local
```bash
bash ./BASH_SERVER_PIPER/script.sh
```
A extensão requer um servidor em **http://localhost:21116**. Verifique se está rodando!

---

## ⚙️ Dependências do Servidor
Para garantir o funcionamento, instale os seguintes pacotes:
```bash
sudo apt install ffmpeg netcat jq
```

Depois, execute o servidor:
```bash
bash ./BASH_SERVER_PIPER/script.sh
```

---

## 🎧 Como Usar
1. Clique no **ícone da extensão** na barra do Chrome.
2. **Selecione um texto** na página.
3. O áudio será gerado automaticamente no popup.
4. **Controles disponíveis:**
   - 🔃 **Regerar áudio**
   - ▶️/⏸️ **Play/Pause**
   - 💾 **Baixar como MP3**
   - 🎚️ **Ajustar Velocidade**: Clique em "Velocidade: Nx" para alternar.

---

## 📂 Estrutura do Projeto
```
FalaTexto/
├── background.js       # Script de background
├── icon.png            # Ícone (48x48 e 128x128)
├── manifest.json       # Configuração da extensão
├── popup.html          # Interface do popup
└── popup.js            # Lógica do popup
```

---

## 📝 Notas Técnicas
- Usa **localStorage** para salvar a velocidade preferida.
- Comunicação com o servidor via **postMessage**.
- O servidor deve retornar uma estrutura JSON:
```json
[{"url": "URL_DO_AUDIO"}]
```

---

## 🤝 Contribuição
Quer ajudar no desenvolvimento? Siga os passos:
```bash
git clone https://github.com/Condiolov/ExtensionChrome.git
cd ExtensionChrome/FalaTexto
git checkout -b minha-feature
# Faça suas alterações
git commit -m 'Adiciona feature X'
git push origin minha-feature
```
Depois, abra um **Pull Request**! 💡

---

## 📜 Licença
Distribuído sob a licença **MIT License**.

---

## ✨ Autor
🔹 **Condiolov** - [GitHub](https://github.com/Condiolov)

💡 **Dica**: Reporte bugs ou sugira melhorias na aba **Issues**!

