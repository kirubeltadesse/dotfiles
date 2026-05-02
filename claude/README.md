# Claude Code Setup

This directory contains Claude Code configuration

## Contents

- `claude.json` - MCP servers configuration
- `settings.json` - Claude Code settings (model, permissions, etc.)
- `skills/` - Custom skills
- `cl` - Claude launcher script for environment
- `setup.sh` - Installation script

## MCP Servers Configured

<!-- TODO: add nb MCP -->

## Skills Available

<!-- TODO: github skills -->

## Installation

At work machine (with `.bbrc` sourced):

```bash
cd ~/.dotfiles
./install.sh claude
```

Or include in full setup:

```bash
./install.sh all
```

## Usage

After setup, use the `cl` command to launch Claude Code:

```bash
cl
```

This will:

1. Run work-specific setup if needed
2. Authenticate with work services
3. Launch Claude Code with proper configuration

## Prerequisites

**jira-cli skill** requires jira-cli to be installed:

```bash
# Clone jira-cli to ~/tools/jira-cli
git clone <jira-cli-repo> ~/tools/jira-cli
cd ~/tools/jira-cli
npm install

# Or set custom path in .bbrc:
export JIRA_CLI_PATH="/path/to/jira-cli"
```

## Work-Only Setup

This setup only activates when `IS_WORK=1` is set (automatically set in `.bbrc`).

On personal machines, this configuration will be skipped during installation.
