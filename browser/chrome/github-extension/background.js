chrome.commands.onCommand.addListener((command) => {
  if (command === "collapse_pr_details") {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
      chrome.tabs.sendMessage(tabs[0].id, { action: "collapse" });
    });
  } else if (command === "expand_pr_details") {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
      chrome.tabs.sendMessage(tabs[0].id, { action: "expand" });
    });
  }
});

