#!/bin/bash

# Load the original script and shunit2


oneTimeSetUp() {
    . "$HOME"/.dotfiles/localhistory/lh.sh
}


# Test create function
test_create_local_history() {
    create "TEST" # Create a local history file
    assertTrue "Local history file should be created" "[ -f $LOCAL_HISTOR ]"
}

# Test swap function
test_swap_history() {
    # Set up initial state
    LOCAL_HISTOR="$HOME/.dotfiles/test.lhistory"
    touch "$LOCAL_HISTOR"  # Create a mock local history file
    CURRENT_LOADED_HISTORY_PATH="$HOME/.bash_history"  # Initial history path
    
    # Test swapping the history files
    swap
    assertEquals "Current loaded history should be $LOCAL_HISTOR" "$LOCAL_HISTOR" "$CURRENT_LOADED_HISTORY_PATH"
}

# Test the cd function for switching to a directory with a local history
test_cd_with_local_history() {
    local test_dir=$(mktemp -d)
    touch "$test_dir/.lhistory"
    cd "$test_dir"
    assertEquals "The local history file should be set" "$test_dir/.lhistory" "$LOCAL_HISTOR"
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

. /opt/homebrew/bin/shunit2  # Path to shunit2 script
