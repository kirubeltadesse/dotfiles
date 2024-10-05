#!/usr/bin/bash

. ./../../utility/utilities.sh

test_custome_installer() {
    custome_installer
    local status=$?
    asserEquals 0 $status
}


# run the tests
. shunit2
