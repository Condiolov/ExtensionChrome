document.addEventListener('DOMContentLoaded', function() {
   chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
      var tab = tabs[0];
      var title = tab.title;
      document.getElementById('site-title').textContent = title;
   });
});
