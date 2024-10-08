#!/usr/bin/bash


oneTimeSetUp() {
    . "$HOME"/.dotfiles/utility/utilities.sh
}


test_read_file() {
    local file="/tmp/dotfiles/command.txt"
    read_file $file
    local status=$?
    assertEquals 0 $status 
}

test_install_apps() {
    install_apps
    local status=$?
    assertEquals 0 $status 
}

test_custome_installer() {
    custome_installer
    local status=$?

    # Disable non-generic tests.
    [ -z "${BASH_VERSION:-}" ] && startSkipping
    assertEquals 0 $status
}

test_create_symlink() {
    create_symlink /tmp/ ./here
    assertTrue 'Fail create dir' "[ -r ./here ]"
    rm ./here                # remove the create symlink
}

test_create_symlink_file_underSubdir() {
    create_symlink /tmp/ ./here/Nosub/temp 
    assertTrue 'Fail create nest dir' "[ -r ./here ]"
    rm -r ./here
}

# run the tests
. shunit2
