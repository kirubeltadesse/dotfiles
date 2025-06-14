FOLDER="$HOME/.dotfiles"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$FOLDER/utility/utilities.sh"

CURRENT_LOADED_HISTORY_PATH="$HOME/.bash_history"
LOCAL_HISTOR=""

# handle the history differently
# http://stackoverflow.com/questions/103944/real-time-history-export-amongst-bash-terminal-windows
# TODO: filter the command in `.lhistory` to include unique history
function hist {
    local lhistory="$1"
    history -a "$1"
    CURRENT_LOADED_HISTORY_PATH="$1"
    history -c # clears the current in-memory command
    newCommands=$(cat "$lhistory")
    if [ "$newCommands" != "" ]; then
        grep -vwE "$newCommands"~/.bash_history >"$lhistory"
        cp "$lhistory" ~/.bash_history
        echo "$newCommands" >>~/.bash_history
    fi
    history -r "$lhistory" # read the modified file into memory
    history -a "$lhistory" # appends the in memory history
    # remove the history file
    # rr ~/.bash_history_aux;
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

function create {
    LOCAL_HISTOR="$(pwd)/.lhistory"

    if [[ ! -f "$LOCAL_HISTOR" ]]; then
        touch "$LOCAL_HISTOR"
        CURRENT_LOADED_HISTORY_PATH="$LOCAL_HISTOR"
        print 'success' "Create a local history $LOCAL_HISTOR"
    else
        print 'warning' "Reading from $LOCAL_HISTOR"
    fi
    history -a "$LOCAL_HISTOR"
    export HISTFILE
    HISTFILE="$LOCAL_HISTOR"
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
