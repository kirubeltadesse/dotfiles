#!/usr/bin/bash

oneTimeSetUp() {
. "$HOME"/.dotfiles/system/.function
}

test_mk(){
    local tempDir="/tmp/dotfilesTest"
    mk $tempDir
    assertTrue 'test failed' "[ -r $tempDir ]"
}

. shunit2
