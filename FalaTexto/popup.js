// popup.js
let pageContent = null;
let iframeLoaded = false;

document.addEventListener("DOMContentLoaded", () => {
	const iframe = document.getElementById("id_Frame");
	console.log("Popup carregado");

	// Listener para mensagens do background.js
	chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
		console.log("popup:", message);

		if (message.type === "pageContent") {
			pageContent = message.data;
			console.log("Conteúdo da página recebido na popup:", pageContent);

			// Se o iframe já estiver carregado, envia a mensagem imediatamente
			if (iframeLoaded) {
				sendMessageToIframe(iframe, pageContent);
			}
		}
	});



	// Listener para quando o iframe é carregado
	iframe.onload = () => {
		console.log("Iframe carregado");
		iframeLoaded = true;

		// Se o pageContent já estiver disponível, envia a mensagem imediatamente
		if (pageContent) {
			sendMessageToIframe(iframe, pageContent);
		}else{

			chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
				const tab = tabs[0];
				const tabId = tab.id;
				const url = tab.url;

				if (url.startsWith("http://") || url.startsWith("https://")) {
					console.log("Executando script na aba:", tabId);
					chrome.scripting.executeScript({
						target: { tabId: tabId },
						function: getPageData
					}, (results) => {
						if (results && results[0] && results[0].result) {


							console.log("Dados recebidos no popup - Texto:", results[0].result.selecionado.substring(0, 100));

							dataToSend = results[0].result;
							if (iframe.contentWindow) {
								iframe.contentWindow.postMessage({
									type: "pageData",
									text: dataToSend.text,
									html: dataToSend.html,
									selecionado: dataToSend.selecionado,
								}, "http://localhost:21116");
							}
						}
					});
				}
			});



	}
	}
});

// Função para enviar mensagem para o iframe
function sendMessageToIframe(iframe, pageContent) {
	// console.log("---->", pageContent)
	// console.log("---->", pageContent.result.pageText)
	iframe.src="http://localhost:21116/"+pageContent.result.pagina

console.log("http://localhost:21116/"+pageContent.result.pagina)

	if (iframe.contentWindow) {
		iframe.contentWindow.postMessage({
			type: "pageData",
			text: pageContent.result.pageText,
			html: pageContent.result.pageHTML,
			selecionado: pageContent.result.selectedText,
		}, "http://localhost:21116");
	}
}

function getPageData() {
	const serializer = new XMLSerializer();
	return {
		text: document.body.innerText,
		html: serializer.serializeToString(document),
		selecionado: window.getSelection().toString()

	};
}