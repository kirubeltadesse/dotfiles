FOLDER="$HOME/.dotfiles"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$FOLDER/utility/utilities.sh"

CURRENT_LOADED_HISTORY_PATH="$HOME/.bash_history"
LOCAL_HISTOR=""

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
    echo "Usage: lh.sh [init|add|remove]"
    echo "Run setup for different local history."
    echo "help        - display help manuel"
    echo "init        - create local history file"
    echo "lh          - Setup localhistory"
    echo "add         - add command to lhistory"
    echo "remove      - remove command to lhistory"
    echo "set         - set http and https proxy"
    echo "unset       - unset http and https proxy"
    echo "swap        - swap loaded history"
    echo "read        - print project history"
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
            localhist_add "$@"
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
    LOCAL_HISTOR="$(pwd)/.lhistory"

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
    echo "$PWD $*" >>"$LOCAL_HISTOR"
}

function swap {
    if [ "$CURRENT_LOADED_HISTORY_PATH" != "$LOCAL_HISTOR" ]; then
        set_history "$LOCAL_HISTOR"
    else
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

function cd {
    builtin cd "$@" || exit
    if [[ -f "$(pwd)/.lhistory" ]]; then
        # load the local history
        LOCAL_HISTOR="$(pwd)/.lhistory"
        # hist "$(pwd)/.lhistory"
        notify "$@"
    else
        export HISTFILE="$HOME/.bash_history"
    fi
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
    builtin history | command grep -E "$@"
    set +f
}

# TODO: create a function to read the .lhistory
# give a bash_completion
# add future like manuel history addition
# https://opensource.com/article/18/3/creating-bash-completion-script
# https://www.youtube.com/watch?v=Ih903YwCKTc&ab_channel=rwxrob
