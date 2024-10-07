#!/usr/bin/bash

. ./../../utility/utilities.sh


# test_install_apps() {
#     install_apps
# }

# test_custome_installer() {
#     custome_installer
#     local status=$?
#     asserEquals 0 $status
# }


test_create_symlink() {
    create_symlink /tmp/ ./here
    rm ./here                # remove the create symlink
}

test_create_symlink_file_underSubdir() {
    create_symlink /tmp/ ./here/Nosub/temp 
    rm -r ./here
}

# run the tests
. shunit2
