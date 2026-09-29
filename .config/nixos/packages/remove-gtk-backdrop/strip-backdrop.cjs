const fs = require("node:fs");
const path = require("node:path");
const { pathToFileURL } = require("node:url");
const { execFileSync } = require("node:child_process");
const postcss = require("postcss");

const targetDir = process.argv[2];

function loadCss(url) {
  if (url.protocol === "resource:") {
    return execFileSync(process.env.GRESOURCE, ["extract", process.env.GTK_LIB, url.pathname], {
      encoding: "utf8",
    });
  }
  return fs.readFileSync(url, "utf8");
}

function expandImports(root, baseUrl) {
  for (const node of [...root.nodes]) {
    if (node.type !== "atrule" || !/^(import|include)$/i.test(node.name)) continue;

    const uri = node.params.match(/^(?:url\()?\s*["']?([^"'()\s]+)/)[1];
    const targetUrl = new URL(uri, baseUrl);
    const importedRoot = postcss.parse(loadCss(targetUrl));

    expandImports(importedRoot, targetUrl);
    node.replaceWith(...importedRoot.nodes);
  }
}

function stripBackdrop(fileUrl) {
  const root = postcss.parse(fs.readFileSync(fileUrl, "utf8"));

  expandImports(root, fileUrl);

  root.walkRules((rule) => {
    const kept = rule.selectors.filter((sel) => !/(?<!:not\(\s*):backdrop\b/.test(sel));
    if (kept.length === 0) {
      rule.remove();
    } else if (kept.length !== rule.selectors.length) {
      rule.selectors = kept;
    }
  });

  fs.writeFileSync(fileUrl, root.toString());
}

for (const entry of fs.readdirSync(targetDir, { recursive: true })) {
  if (entry.endsWith(".css")) {
    stripBackdrop(pathToFileURL(path.resolve(targetDir, entry)));
  }
}
