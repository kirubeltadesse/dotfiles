#!/opt/homebrew/bin/bash

# Load the original script and shunit2
oneTimeSetUp() {
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    LH_SH_PATH="$SCRIPT_DIR/../../localhistory/lh.sh"
    source "$LH_SH_PATH"
}

# Helper to create a fake git repo with optional .lhistory
setup_repo() {
    TEST_DIR=$(mktemp -d)
    cd "$TEST_DIR" || exit
    mkdir .git
    if [[ "$1" == "with_history" ]]; then
        echo "history entry" >.lhistory
    fi
}

# Test: No .git directory
test_no_git_dir() {
    TMP=$(mktemp -d)
    cd "$TMP" || exit
    output=$(lh_read 2>&1)
    assertEquals "No .git directory found." "$output"
}

# Test: .git exists, no .lhistory
test_no_lhistory() {
    setup_repo
    output=$(lh_read 2>&1)
    assertEquals "No project history found." "$output"
}

# Test: .git and .lhistory exist
test_with_lhistory() {
    setup_repo with_history
    output=$(lh_read 2>&1)
    assertEquals "history entry" "$output"
}

# Test create function
# test_create_local_history() {
#     TMP=$(mktemp -d)
#     cd "$TMP" || exit
#     touch .git
#     create "TEST" # Create a local history file
#     assertTrue "Local history file should be created" "[ -f $LOCAL_HISTORY]"
# }

# Test swap function
# test_swap_history() {
#     TMP=$(mktemp -d)
#     cd "$TMP" || exit
#     touch .git
#     LOCAL_HISTORY="$TMP/.lhistory"
#     touch "$LOCAL_HISTORY"
#     CURRENT_LOADED_HISTORY_PATH="$HOME/.bash_history"
#     swap
#     assertEquals "Current loaded history should be $LOCAL_HISTORY" "$LOCAL_HISTORY" "$CURRENT_LOADED_HISTORY_PATH"
# }

# Test the cd function for switching to a directory with a local history
test_cd_with_local_history() {
    test_dir=$(mktemp -d)
    touch "$test_dir/.lhistory"
    cd "$test_dir" || exit
    cd_with_local_history
    assertEquals "The local history file should be set" "$test_dir/.lhistory" "$LOCAL_HISTORY"
}

# Test history_grep function
test_history_grep() {

    TMP=$(mktemp -d)
    cd "$TMP"
    touch .git
    echo "sample" >.lhistory
    LOCAL_HISTORY="$TMP/.lhistory"
    export LOCAL_HISTORY
    last_command=$(tail -n 1 "$LOCAL_HISTORY")
    assertEquals "Command should match history" "sample" "$last_command"
}

. /opt/homebrew/bin/shunit2 # Path to shunit2 script
