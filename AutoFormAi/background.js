chrome.action.onClicked.addListener((tab) => {
  chrome.scripting.executeScript({
    target: { tabId: tab.id },
    function: getTitle,
  });
});

// Escutando mensagem vinda do popup
chrome.runtime.onMessage.addListener((request, sender,
                                      sendResponse) => {
                                        if (request.action === "getTitle") {
                                          const title = getTitle();
                                          sendResponse({ title });
                                        }
                                      });

function getTitle() {
  return document.title;
}
