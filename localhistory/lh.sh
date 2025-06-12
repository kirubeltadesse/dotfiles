FOLDER="$HOME/.dotfiles"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$FOLDER/utility/utilities.sh"

CURRENT_LOADED_HISTORY_PATH="$HOME/.bash_history"
LOCAL_HISTORY=""

function find_project_root {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.git" ]]; then
            echo "$dir"
            return
        fi
        dir=$(dirname "$dir")
    done
    return 1
}

function log_to_playbook {
    local root last_command playbook_file
    root=$(find_project_root) || return
    playbook_file="$root/.playbook.sh"
    last_command=$(history 2 | sed 's/ *[0-9]* *//')

    # Ignore generic commands and empty lines
    case "$last_command" in
    "" | "ls"* | "cd"* | "pwd" | "clear" | "exit" | "history"* | "lh "*) return ;;
    esac

    # Only add if not already the last entry in playbook
    if [[ ! -f "$playbook_file" ]] || [[ "$(tail -n 1 "$playbook_file")" != "$last_command" ]]; then
        echo "$last_command" >>"$playbook_file"
    fi
    # Add to PROMPT_COMMAND so it runs after every command
    # PROMPT_COMMAND="log_to_playbook${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

    # # Wrapper to call log_to_playbook from a key binding
    # log_to_playbook_binding() {
    #     log_to_playbook
    #     # Optionally, you can print a message or refresh prompt
    # }
    # export -f log_to_playbook_binding

    # # Assign Ctrl+g (for example) to call the function
    # bind -x '"\C-g":log_to_playbook_binding'
}

# handle the history differently
# http://stackoverflow.com/questions/103944/real-time-history-export-amongst-bash-terminal-windows
# TODO: filter the command in `.lhistory` to include unique history
function hist {
    local lhistory="$1"

    # save history to the specified file
    history -a "$lhistory"
    CURRENT_LOADED_HISTORY_PATH="$lhistory"
    history -c # clears the current in-memory command

    # Update the history file with the new commands
    newCommands=$(cat "$lhistory")
    if [ "$newCommands" != "" ]; then
        grep -vwE "$newCommands"~/.bash_history >"$lhistory"
        cp "$lhistory" ~/.bash_history
        echo "$newCommands" >>~/.bash_history
    fi

    history -r "$lhistory" # Reload modified history
    history -a "$lhistory" # Append in-memory history to the file
}

function show_help {
    cat <<EOF
Usage: lh.sh [init|add|remove]
Run setup for different local history.
help        - display help manuel
init        - create local history file
lh          - Setup localhistory
add         - add command to lhistory
remove      - remove command to lhistory
set         - set http and https proxy
unset       - unset http and https proxy
swap        - swap loaded history
read        - print project history
py          - Add command to playbook
EOF
}

function lh() {
    for arg in "$@"; do
        case $arg in
        help)
            show_help
            ;;
        init)
            create "$@"
            ;;
        add)
            localhist_add "${@:1}"
            ;;
        grep)
            history_grep "${@:2}"
            ;;
        remove)
            remove
            ;;
        info)
            notify
            ;;
        set)
            set_proxy
            ;;
        unset)
            unset_proxy
            ;;
        swap)
            swap
            ;;
        read)
            lh_read
            ;;
        py)
            log_to_playbook
            ;;
        *)
            show_help
            # exit 1
            ;;
        esac
    done
}

function notify {
    print "warning" "read .lhistory from $CURRENT_LOADED_HISTORY_PATH"
    return
}

# Initialize project history
function lh_init {
    local root
    root=$(find_project_root) || {
        echo "No .git directory found."
        return 1
    }
    export LHIST_FILE="$root/.lhistory"
    touch "$LHIST_FILE"
    echo "Project history file: $LHIST_FILE"

    # Set up PROMPT_COMMAND to log commands, filtering out generic ones
    function lh_log_command {
        local last_command
        last_command=$(history 1 | sed 's/ *[0-9]* *//')
        if [[ "$last_command" != "lh" && "$last_command" != "lh "* ]]; then
            echo "$last_command" >>"$LHISTORY_FILE"
        fi
        case "$last_command" in
        cd* | ls* | pwd | clear | exit) return ;; # Ignore generic command
        esac
        if [[ -n "$last_command" ]]; then
            echo "$last_command" >>"$LHIST_FILE"
        fi
    }
    PROMPT_COMMAND="lh_log_command${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
}

# Read project history
function lh_read {
    local root
    root=$(find_project_root) || {
        echo "No .git directory found."
        return 1
    }
    local file="$root/.lhistory"
    if [[ -f "$file" ]]; then
        cat "$file"
    else
        echo "No project history found."
    fi
}

# create: Initializes or loads a local history file for the current directory.
# - Creates a .lhistory file in the current working directory if it does not exist.
# - Sets HISTFILE to the local history file for the current shell session.
# - Appends the current command and working directory to the history file.
function create {
    LOCAL_HISTORY="$(pwd)/.lhistory"

    if [[ ! -f "$LOCAL_HISTORY" ]]; then
        touch "$LOCAL_HISTORY"
        CURRENT_LOADED_HISTORY_PATH="$LOCAL_HISTORY"
        print 'success' "Create a local history $LOCAL_HISTORY"
    else
        print 'warning' "Reading from $LOCAL_HISTORY"
    fi

    history -a "$LOCAL_HISTORY"
    export HISTFILE="$LOCAL_HISTORY"
    print 'warning' "History file set to $HISTFILE"

    # Append the command to the local history file
    echo "$PWD $*" >>"$LOCAL_HISTORY"
}

function swap {
    local root
    root=$(find_project_root) || {
        print 'warning' "No .git direcotry found, using defaults history"
        set_history "$HOME/.bash_history"
        return
    }
    local lhistory_path="$root/.lhistory"
    if [[ -f "$lhistory_path" ]]; then
        LOCAL_HISTORY="$lhistory_path"
        if [ "$CURRENT_LOADED_HISTORY_PATH" != "$LOCAL_HISTORY" ]; then
            set_history "$LOCAL_HISTORY"
        else
            set_history "$HOME/.bash_history"
        fi
    else
        print 'warning' "No .lhistory found in $root, using default history."
        set_history "$HOME/.bash_history"
    fi
    return
}

function set_history {
    # update the current session history
    history -a "$1"
    CURRENT_LOADED_HISTORY_PATH="$1"
    history -r "$1"
    return
}

cd_with_local_history() {
    if [[ -f "$(pwd)/.lhistory" ]]; then
        LOCAL_HISTORY="$(pwd)/.lhistory"
        notify "$@"
    else
        export HISTFILE="$HOME/.bash_history"
    fi
}

function cd {
    builtin cd "$@" || exit
    cd_with_local_history
}

function localhist_add { # add to HISTFILE
    local text_source=std
    local prepend
    local text
    while [[ -n $1 ]]; do
        case $1 in
        -h | --help)
            builtin echo "localhist_add [--comment|-c] [--file|-f <path>] [-- args as text]"
            return
            ;;
        -c | --comment) # Add text after a '#' comment indicator
            prepend="# "
            ;;
        -f | --file) # Get text from specified file
            text_source="${2}"
            shift
            ;;
        --) # Anything following is the text itself
            text_source=args
            shift
            break
            ;;
        esac
        shift
    done
    case $text_source in
    stdin)
        if [[ -t 2 && -t 0 ]]; then
            builtin read -r -p "Enter text for new history event: " text
        else
            builtin read -r text
        fi
        ;;
    args)
        text="$*"
        ;;
    *)
        [[ -r ${text_source} ]] || {
            builtin echo "ERROR: can't read text from the file \"${text_source}\" " >&2
            false
            return
        }
        text=$(command cat "${text_source}" | command tr '\n' ';')
        ;;
    esac
    builtin history -s "${prepend}${text}"

}

function history_grep {
    history | command grep -E "$@"
}

# TODO: create a function to read the .lhistory
# give a bash_completion
# add future like manuel history addition
# https://opensource.com/article/18/3/creating-bash-completion-script
# https://www.youtube.com/watch?v=Ih903YwCKTc&ab_channel=rwxrob
