---
name: nb
description: Manage notes, bookmarks, and todos using the nb CLI. Use when users mention notes, notebooks, bookmarks, todos, journaling, or nb. Supports creating, searching, listing, editing, and organizing notes across multiple notebooks.
argument-hint: "[describe what you want to do with your notes]"
allowed-tools: Bash
---

# nb — Note-Taking CLI Skill

You help users manage their notes, bookmarks, and todos using the `nb` CLI tool.

**Tool:** [nb](https://github.com/xwmx/nb) (v7.25.3)
**Binary:** `/opt/homebrew/bin/nb`
**Data:** `~/.nb/` (Git-backed plain text)

## Notebooks

The user has these notebooks configured:

| Notebook | Remote |
|---|---|
| `home` | (local only) |
| `mine` | `https://github.com/kirubeltadesse/PersonalJournal.git` |
| `work` | `git@bbgithub.dev.bloomberg.com:ktadesse1/BQL-tutorial.git` |

Switch notebooks with `nb use <notebook>` or prefix commands with `<notebook>:` (e.g. `work:ls`).

## Common Operations

### List Notes

```bash
# List notes in the current notebook
nb ls

# List with excerpts
nb ls -e

# List notes in a specific notebook
nb ls work:

# List only bookmarks
nb ls --type bookmark

# List only todos
nb ls --type todo

# List by tag
nb ls --tags
nb ls -t tag1,tag2
```

### Create Notes

```bash
# Add a note with content (non-interactive)
nb add --title "My Note Title" -c "Note content here"

# Add a note to a specific notebook
nb add work: --title "Meeting Notes" -c "Discussion points..."

# Add with tags
nb add --title "Tagged Note" -c "Content" --tags project,important

# Add a todo
nb add todo "Complete the quarterly report"

# Add a bookmark
nb bookmark "https://example.com" --title "Example Site" --tags reference
```

### View Notes

```bash
# Show a note by ID (prints to stdout)
nb show <id> --print

# Show a note by title
nb show "My Note Title" --print

# Show note from a specific notebook
nb show work:<id> --print

# Show just the title
nb show <id> --title

# Show the file path
nb show <id> --path
```

### Search Notes

```bash
# Full-text search across current notebook
nb search "query"

# Search all notebooks
nb search "query" --all

# Search with AND/OR/NOT
nb search "query1" --and "query2"
nb search "query1" --or "query2"
nb search "query1" --not "exclude"

# Search by tag
nb search --tag tag1,tag2

# List matching files (no excerpts)
nb search "query" --list
```

### Edit Notes

```bash
# Append content to a note
nb edit <id> -c "Additional content"

# Prepend content
nb edit <id> -c "New top content" --prepend

# Overwrite content entirely
nb edit <id> -c "Replacement content" --overwrite
```

### Delete Notes

```bash
# Delete a note (with confirmation)
nb delete <id>

# Force delete (no confirmation)
nb delete <id> --force
```

### Todos

```bash
# Add a todo
nb add todo "Task description"

# Mark a todo as done
nb do <id>

# Undo a completed todo
nb undo <id>

# List all todos
nb ls --type todo

# List open tasks within a todo note
nb tasks <id>
```

### Organization

```bash
# Move a note to another notebook
nb move <id> <notebook>:

# Copy a note
nb copy <id>

# Pin/unpin a note (pinned items appear first)
nb pin <id>
nb unpin <id>

# Create a folder
nb add folder "folder-name"

# Move note into a folder
nb move <id> folder-name/
```

### Sync & Git

```bash
# Sync current notebook with remote
nb sync

# Check sync status
nb status

# Manual git checkpoint
nb git checkpoint "message"
```

### Notebooks Management

```bash
# List notebooks
nb notebooks

# Create a new notebook
nb notebooks add <name>

# Switch to a notebook
nb use <notebook>

# Add a remote to a notebook
nb remote set <url>
```

## Workflow

1. **Identify** which notebook the user wants to work with (default: current)
2. **Use non-interactive flags** (`-c`, `--title`, `--print`, `--force`) — avoid opening an editor
3. **Prefer `--print`** when showing notes so content appears in the terminal
4. **Always confirm** before deleting notes
5. **Sync** after modifications if the notebook has a remote
