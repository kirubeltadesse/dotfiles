function toggleAllFiles(expand) {
  // Each file container uses GitHub's hashed CSS-module class; match by stable prefix.
  const files = document.querySelectorAll('[class*="Diff-module__diffTargetable"]');
  files.forEach((file) => {
    // The collapse/expand control is the leading IconButton in the file header.
    const header = file.querySelector('[class*="DiffFileHeader-module__diff-file-header"]');
    if (!header) return;
    const btn = header.querySelector('button[data-component="IconButton"]');
    if (!btn) return;
    // State is reflected by the chevron icon: down = expanded, right = collapsed.
    const isExpanded = !!btn.querySelector('svg.octicon-chevron-down');
    if (isExpanded !== expand) btn.click();
  });
}

function runWithRetry(action, tries) {
  tries = tries === undefined ? 8 : tries;
  // Re-query at call time; retry briefly in case diffs are still rendering (Turbo nav).
  if (document.querySelectorAll('[class*="Diff-module__diffTargetable"]').length === 0 && tries > 0) {
    setTimeout(function () { runWithRetry(action, tries - 1); }, 150);
    return;
  }
  action();
}

chrome.runtime.onMessage.addListener((message) => {
  if (message.action === "collapse") {
    runWithRetry(function () { toggleAllFiles(false); });
  } else if (message.action === "expand") {
    runWithRetry(function () { toggleAllFiles(true); });
  }
});
