var id_popup = null; // Armazena o ID da janela pop-up


function sendMessageToNativeApp(message) {
   const port = chrome.runtime.connectNative('com.falatexto.nmh');

   // Envia a mensagem (deve ser um objeto JSON)
   port.postMessage(message);

   // Recebe a resposta do Native Messaging Host
   port.onMessage.addListener((response) => {
      console.log("Resposta do Native Messaging Host:", response);
   });

   // Lidar com desconexão
   port.onDisconnect.addListener(() => {
      if (chrome.runtime.lastError) {
         console.error("Erro ao conectar ao Native Messaging Host:", chrome.runtime.lastError.message);
      } else {
         console.log("Desconectado do Native Messaging Host.");
      }
   });
}

// Exemplo de uso



// Cria o menu de contexto
chrome.runtime.onInstalled.addListener(() => {
   console.log("Extensão FalaTexto instalada.");
   // Remove o item de menu de contexto existente (se houver)
   chrome.contextMenus.remove("sendText", () => {
      // Verifica se houve um erro ao remover o item
      if (chrome.runtime.lastError) {
         console.log("Item de menu de contexto não existia ou já foi removido.");

      }

      // Cria o item de menu de contexto
      chrome.contextMenus.create({
         id: "sendText",
         title: "Enviar Texto Selecionado",
         contexts: ["selection"]
      });
   });
});


// Exemplo de como enviar uma mensagem
// sendMessageToNativeApp({ action: "start", text: "Olá, mundo!" });


// Listener para o menu de contexto
chrome.contextMenus.onClicked.addListener((info, tab) => {
   if (info.menuItemId === "sendText" && info.selectionText) {
      const selectedText = info.selectionText;
      sendMessageToNativeApp({ action: "start", text: "Olá, mundo!" });
      // Fecha a janela pop-up existente (se houver)
      if (id_popup !== null) {
         chrome.windows.remove(id_popup, () => {
            if (chrome.runtime.lastError) {
               console.error("Erro ao fechar a janela:", chrome.runtime.lastError);
            } else {
               console.log("Janela pop-up fechada com sucesso.");
               id_popup = null; // Reseta o ID da janela
            }

            // Abre uma nova janela pop-up
            openNewPopup(tab, selectedText);
         });
      } else {
         // Abre uma nova janela pop-up
         openNewPopup(tab, selectedText);
      }
   }
});

// Função para abrir uma nova janela pop-up
function openNewPopup(tab, selectedText) {
   chrome.windows.create({
      url: chrome.runtime.getURL("popup.html"),
                         type: "popup",
                         width: 150,
                         height: 60,
                         focused: true
   }, (window) => {
      id_popup = window.id; // Armazena o ID da nova janela
      console.log("Nova janela pop-up criada com ID:", window.tabs[0].id, "-----", window.id);

      // Injeta o Content Script na página ativa
      chrome.scripting.executeScript({
         target: { tabId: tab.id },
         function: getPageContent,
      }, (results) => {
         if (results && results[0]) {
            const pageContent = results[0];
            console.log("Conteúdo da página background:", pageContent);

            // Envia os dados para a nova popup após um pequeno atraso
            setTimeout(() => {
               chrome.tabs.sendMessage(window.tabs[0].id, {
                  type: "pageContent",
                  data: pageContent,
               });
            }, 1000); // Atraso para garantir que a janela esteja pronta
         }
      });
   });
}

// Função para coletar o conteúdo da página (será executada no contexto da página)
function getPageContent() {
   const selectedText = window.getSelection().toString();
   const pageText = document.body.innerText;
   const pageHTML = document.documentElement.outerHTML;
   const pagina = "menu_context.html";

   return {
      selectedText,
      pageText,
      pageHTML,
      pagina
   };
}