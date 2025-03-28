function togglePRDetails(expand) {
  document.querySelectorAll(".file-info button[aria-expanded]").forEach(btn => {
    if (btn.getAttribute('aria-expanded') === (expand ? 'false' : 'true')) {
      btn.click();
    }
  });
}

chrome.runtime.onMessage.addListener((message) => {
  if (message.action === "collapse") {
    togglePRDetails(false);
  } else if (message.action === "expand") {
    togglePRDetails(true);
  }
});

