FOLDER="$HOME/.dotfiles"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$FOLDER/utility/utilities.sh"

# handle the history differently
# http://stackoverflow.com/questions/103944/real-time-history-export-amongst-bash-terminal-windows
# TODO: filter the command in `.lhistory` to include unique history
function hist() {
  local lhistory="$1"
  history -a "$lhistory" # update the current session history
  history -c           # clears the current in-memory command
  newCommands=$(cat "$lhistory")
  if [ "$newCommands" != "" ]; then
    grep -vwE "$newCommands"~/.bash_history >"$lhistory"
    cp "$lhistory" ~/.bash_history
    echo "$newCommands" >>~/.bash_history
  fi
  history -r # read the modified file into memory
  history -a # appends the in momory history
  # remove the history file
  # rr ~/.bash_history_aux;
}


function show_help() {
    echo "Usage: lh.sh [init|add|remove]"
    echo "Run setup for different local history."
    echo "help        - display help manuel"
    echo "init        - create local history file"
    echo "lh          - Setup localhistory"
    echo "add         - add command to lhistory"
    echo "remove      - remove command to lhistory"
    echo "set         - set http and https proxy"
    echo "unset       - unset http and https proxy"
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
                add
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
            *)
                show_help
                # exit 1
                ;;
        esac
    done
}

function notify()
{
     if [ $# -eq 0 ]; then
        print "warning" "read current directory .lhistory"
        return
     fi
    print "warning" "read .lhistory from $1"
}

function create() {
  local history_path
  history_path="$(pwd)/.lhistory"

  if [[ ! -f "$history_path" ]]; then
    touch "$history_path"
    print 'success' "Create a local history $history_path"
  else
    print 'warning' "Reading from $history_path"
  fi
  history -a "$history_path"
  export HISTFILE
  HISTFILE="$(pwd)/.lhistory"
  print 'warning' "History file set to $HISTFILE"

  # Append the command to the local history file
  echo "$PWD $*" >>"$history_path"
}

# TODO: user should be able to pick the history that they want to read
function cd() {
  builtin cd "$@" || exit
  if [[ -f "$(pwd)/.lhistory" ]]; then
    notify "$@"
    # hist "$(pwd)/.lhistory"
  else
    export HISTFILE="$HOME/.bash_history"
  fi
}

# TODO: create a function to read the .lhistory
# give a bash_completion
# add future like manuel history addition
# https://opensource.com/article/18/3/creating-bash-completion-script
# https://www.youtube.com/watch?v=Ih903YwCKTc&ab_channel=rwxrob
