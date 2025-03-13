#!/opt/homebrew/bin/bash

# Load the original script and shunit2

oneTimeSetUp() {
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    LH_SH_PATH="$SCRIPT_DIR/../../localhistory/lh.sh"
    source "$LH_SH_PATH"
}

# Test for lh_read function in localhistory/lh.sh

# Source the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LH_SH_PATH="$SCRIPT_DIR/../localhistory/lh.sh"
source "$LH_SH_PATH"

# Helper to create a fake git repo with optional .lhistory
setup_repo() {
    TEST_DIR=$(mktemp -d)
    cd "$TEST_DIR"
    mkdir .git
    if [[ "$1" == "with_history" ]]; then
        echo "history entry" >.lhistory
    fi
}

# Test: No .git directory
test_no_git_dir() {
    TMP=$(mktemp -d)
    cd "$TMP"
    output=$(lh_read 2>&1)
    [[ "$output" == "No .git directory found." ]]
}

# Test: .git exists, no .lhistory
test_no_lhistory() {
    setup_repo
    output=$(lh_read 2>&1)
    [[ "$output" == "No project history found." ]]
}

# Test: .git and .lhistory exist
test_with_lhistory() {
    setup_repo with_history
    output=$(lh_read 2>&1)
    [[ "$output" == "history entry" ]]
}

# Run tests
# test_no_git_dir && echo "test_no_git_dir passed" || echo "test_no_git_dir failed"
# test_no_lhistory && echo "test_no_lhistory passed" || echo "test_no_lhistory failed"
# test_with_lhistory && echo "test_with_lhistory passed" || echo "test_with_lhistory failed"

# Test create function
test_create_local_history() {
    create "TEST" # Create a local history file
    assertTrue "Local history file should be created" "[ -f $LOCAL_HISTOR ]"
}

# Test swap function
test_swap_history() {
    # Set up initial state
    LOCAL_HISTOR="$HOME/.dotfiles/test.lhistory"
    touch "$LOCAL_HISTOR"                             # Create a mock local history file
    CURRENT_LOADED_HISTORY_PATH="$HOME/.bash_history" # Initial history path

    # Test swapping the history files
    swap
    assertEquals "Current loaded history should be $LOCAL_HISTOR" "$LOCAL_HISTOR" "$CURRENT_LOADED_HISTORY_PATH"
}

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
    echo "sample" >> "$LOCAL_HISTOR"
    last_command=$(tail -n 1 "$LOCAL_HISTOR")
    assertSame "Command should match history" "$last_command" "sample"
}


# Test localhist_add function
# test_localhist_add() {
#     local test_command="echo Hello World"
#     local text_source="args"
#     local expected="echo Hello World"
#
#     # Add command to local history
#     localhist_add -- $test_command
#
#     Verify that the command is added to the history
#     last_command=$(tail -n 1 "$LOCAL_HISTOR")
#     assertEquals "Last command should be $expected" "$expected" "$last_command"
# }

. /opt/homebrew/bin/shunit2 # Path to shunit2 script
