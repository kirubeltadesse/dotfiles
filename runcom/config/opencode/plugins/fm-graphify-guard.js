import { realpathSync } from "node:fs";
import { resolve } from "node:path";
import { spawn } from "node:child_process";

// PreToolUse seatbelt for OpenCode: prevents agents from loading the graphify
// directory into context. Graphify outputs (graphify-out/, graph.json,
// .graphify_*) are large generated artifacts that should be queried via
// `graphify query`/`graphify explain` commands instead of read directly.
//
// This blocks tools that would load graphify files into context:
//   - read/glob/grep with paths matching graphify artifacts
//   - bash commands like cat/ls/head/tail/find on graphify paths
//
// Allowed (returns normally):
//   - `graphify query "..."`, `graphify explain "..."`, etc.
//   - `graphify extract . --code-only`
//   - Any non-graphify path

const GRAPHIFY_PATH_PATTERNS = [
  /(^|[\s/'"`])graphify-out\//,
  /(^|[\s/'"`])graphify-out$/,
  /(^|[\s/'"`])graph\.json$/,
  /(^|[\s/'"`])\.graphify_[^/'"`\s]*( |$|"|'|`)/,
];

function matchesGraphifyPath(path) {
  if (!path || typeof path !== "string") return false;
  return GRAPHIFY_PATH_PATTERNS.some((re) => re.test(path));
}

function runProcess(command, args) {
  return new Promise((resolvePromise) => {
    const child = spawn(command, args, { stdio: ["ignore", "pipe", "pipe"] });
    let stdout = "";
    let stderr = "";
    child.stdout.on("data", (chunk) => {
      stdout += chunk.toString();
    });
    child.stderr.on("data", (chunk) => {
      stderr += chunk.toString();
    });
    child.on("error", () => resolvePromise({ code: 0, stdout: "", stderr: "" }));
    child.on("close", (code) => resolvePromise({ code: code ?? 0, stdout, stderr }));
  });
}

async function resolveRoot(anchor) {
  if (!anchor) return "";
  const result = await runProcess("git", ["-C", anchor, "rev-parse", "--show-toplevel"]);
  const root = result.stdout.trim();
  if (result.code === 0 && root) return root;
  try {
    return realpathSync(anchor);
  } catch {
    return resolve(anchor);
  }
}

function extractPathsFromBashCommand(command) {
  const paths = [];
  const tokens = command.split(/\s+/);
  for (const token of tokens) {
    const cleaned = token.replace(/^["'`]|["'`]$/g, "");
    if (
      cleaned.startsWith("/") ||
      cleaned.startsWith("./") ||
      cleaned.startsWith("../") ||
      cleaned.includes("graphify") ||
      cleaned.includes("graph.json")
    ) {
      paths.push(cleaned);
    }
  }
  return paths;
}

export const FmGraphifyGuard = async ({ directory, worktree }) => {
  const root = worktree
    ? (() => {
        try {
          return realpathSync(worktree);
        } catch {
          return resolve(worktree);
        }
      })()
    : await resolveRoot(directory);

  return {
    "tool.execute.before": async (input, output) => {
      if (!root) return;

      const tool = input?.tool;
      const args = output?.args;

      if (tool === "read" || tool === "glob") {
        const filePath = args?.filePath || args?.path || args?.pattern || "";
        if (matchesGraphifyPath(filePath)) {
          throw new Error(
            `graphify guard: do not load graphify artifacts directly. Use \`graphify query "<question>"\` or \`graphify explain "<concept>"\` instead.`,
          );
        }
      }

      if (tool === "bash") {
        const command = output?.args?.command;
        if (!command || typeof command !== "string") return;

        if (/\bgraphify\s+(query|explain|god-nodes|path|affected|extract)\b/.test(command)) {
          return;
        }

        const paths = extractPathsFromBashCommand(command);
        for (const path of paths) {
          if (matchesGraphifyPath(path)) {
            throw new Error(
              `graphify guard: do not load graphify artifacts directly. Use \`graphify query "<question>"\` or \`graphify explain "<concept>"\` instead.`,
            );
          }
        }
      }
    },
  };
};