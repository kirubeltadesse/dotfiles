#!/opt/homebrew/bin/bash

oneTimeSetUp() {
    . "$HOME"/.dotfiles/utility/utilities.sh
}

test_read_file() {
    local file="/tmp/dotfiles/command.txt"
    read_file $file
    local status=$?
    assertEquals 0 $status
}

test_custome_installer_dry_run_macOS() {
    # Mock uname to return Darwin
    uname() { echo "Darwin"; }
    # Mock brew and other system-changing commands
    brew() { echo "brew $*"; }
    print() { :; }
    write_to_file() { :; }

    output=$(custome_installer true)
    assertContains "$output" "brew install fd"
    assertContains "$output" "brew install --cask rectangle"
    assertContains "$output" "brew install --cask font-jetbrains-mono-nerd-font"
}

test_custome_installer_dry_run_Linux() {
    uname() { echo "Linux"; }
    apt-get() { echo "apt-get $*"; }
    sudo() { echo "sudo $*"; }
    print() { :; }
    write_to_file() { :; }

    output=$(custome_installer true)
    assertContains "$output" "apt-get install -y xclip fd-find"
}

test_install_apps_installs_missing_packages() {
    # Mock read_file to return a fake installer command
    read_file() { echo "echo installing"; }
    # Mock package_installed: return 1 (not installed) for all
    package_installed() { return 1; }
    print() { :; }

    output=$(install_apps)
    # Check that the installer command was called for at least one package
    echo "$output" | grep -q "installing dos2unix"
    assertEquals 0 $?
}

test_install_apps_skips_installed_packages() {
    read_file() { echo "echo installing"; }
    # Mock package_installed: return 0 (installed) for all
    package_installed() { return 0; }
    print() { :; }

    output=$(install_apps)
    # Should not attempt to install any package
    echo "$output" | grep -q "installing"
    assertNotEquals 0 $?
}

test_create_symlink_creates_link() {
    tmpdir=$(mktemp -d)
    src_file="$tmpdir/source.txt"
    tgt_file="$tmpdir/target/linked.txt"
    mkdir -p "$(dirname "$tgt_file")"
    echo "hello" >"$src_file"

    print() { :; } # Suppress print output

    create_symlink "$src_file" "$tgt_file"

    assertTrue "Symlink was not created" "[ -L \"$tgt_file\" ]"
    assertEquals "$src_file" "$(readlink "$tgt_file")"

    rm -rf "$tmpdir"
}

test_create_symlink_skips_existing() {
    tmpdir=$(mktemp -d)
    src_file="$tmpdir/source.txt"
    tgt_file="$tmpdir/target/linked.txt"
    mkdir -p "$(dirname "$tgt_file")"
    echo "hello" >"$src_file"
    echo "existing" >"$tgt_file"

    print() { :; } # Suppress print output

    output=$(create_symlink "$src_file" "$tgt_file" 2>&1)
    assertFalse "Should not overwrite existing file" "[ -L \"$tgt_file\" ]"

    rm -rf "$tmpdir"
}

# run the tests
. shunit2
