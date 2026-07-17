#!/bin/bash

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
CLAUDE_DIR="$DOTFILES_DIR/claude"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info "Setting up Claude Code for ..."

# Create .claude directory if it doesn't exist
mkdir -p ~/.claude

# Copy Claude settings and statusline-command
if [ -f "$CLAUDE_DIR/settings.json" ]; then
    print_info "Copying Claude settings..."
    cp "$CLAUDE_DIR/settings.json" ~/.claude/settings.json
    cp "$CLAUDE_DIR/statusline-command.sh" ~/.claude/statusline-command.sh
fi

# Copy skills
if [ -d "$CLAUDE_DIR/skills" ]; then
    print_info "Copying Claude skills..."
    cp -r "$CLAUDE_DIR/skills" ~/.claude/

    # Process jira-cli skill template if it exists
    if [ -f "$CLAUDE_DIR/skills/jira-cli/SKILL.template.md" ]; then
        print_info "Setting up jira-cli skill..."
        JIRA_CLI_PATH="${JIRA_CLI_PATH:-$HOME/tools/jira-cli}"

        if [ -d "$JIRA_CLI_PATH" ]; then
            # Replace {{INSTALL_PATH}} with actual path
            sed "s|{{INSTALL_PATH}}|$JIRA_CLI_PATH|g" \
                "$CLAUDE_DIR/skills/jira-cli/SKILL.template.md" \
                >~/.claude/skills/jira-cli/SKILL.md
            print_info "jira-cli skill configured with path: $JIRA_CLI_PATH"
        else
            print_warning "jira-cli not found at $JIRA_CLI_PATH"
            print_info "Set JIRA_CLI_PATH environment variable or install to $JIRA_CLI_PATH"
        fi
    fi
fi

# Create symlink for claude.json (MCP servers config)
if [ -f "$CLAUDE_DIR/claude.json" ]; then
    print_info "Setting up MCP servers configuration..."
    if [ -f ~/.claude.json ]; then
        print_warning "Backing up existing ~/.claude.json to ~/.claude.json.backup"
        mv ~/.claude.json ~/.claude.json.backup
    fi
    ln -sf "$CLAUDE_DIR/claude.json" ~/.claude.json
fi

# Create symlink for cl launcher script
if [ -f "$CLAUDE_DIR/cl" ]; then
    print_info "Setting up 'cl' launcher command..."
    chmod +x "$CLAUDE_DIR/cl"
    # Add to PATH via function in .bbrc instead of system-wide symlink
    print_info "Add this to your .bbrc to use 'cl' command:"
    echo -e "${YELLOW}export PATH=\"\$HOME/.dotfiles/claude:\$PATH\"${NC}"
fi

print_info "Claude setup complete!"
