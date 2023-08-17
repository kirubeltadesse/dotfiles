source "../utility/utilities.sh"

IFS=$'\n'

extension="`pwd`/extensions"
`code --list-extensions > currentListOfExtensions`

# this commend only writes the unique lines from currentListOfExtenstions but not in
# extenstions
# get the unique extenstions that are not in the list
# get readoff private extenstion [... Bloomberg]
# remove the extension for java and Bloomberg 
addExtensions=$(grep -Fxvf extensions currentListOfExtensions | grep -v -i -e 'bloomberg' -e 'java')

# append the to the list of extesion
echo "$addExtensions" >> "$extension"

if [ -z "$addExtensions" ]; then
	print "No extenstion to update"
else 
	print warning "This extenstion has been updated\n${addExtensions}" # note -e option is used to enable 
	# interpretation of backslash
fi

# remove the newExtenstions file
`rm currentListOfExtensions`

# TODO: filter bloomberg settings
# check the Operating system

os=$(uname)

settings=""
keybindings=""

if [ "$os" == "Darwin" ]; then
	settings="$HOME/Library/Application Support/Code/User/settings.json"
	keybindings="$HOME/Library/Application Support/Code/User/keybindings.json"
	print warning "setting loc for ${os}:\n ${settings}"
elif [ "$os" == "Linux" ]; then
	settings="/mnt/c/Users/kiyam/AppData/Roaming/Code/User/settings.json"
	keybindings="/mnt/c/Users/kiyam/AppData/Roaming/Code/User/keybindings.json"
	print warning "setting loc for $os: \n ${settings}"
else 
	print error "system not indentified"
fi

settings_file="`pwd`/settings.json"

keybinds_file="`pwd`/keybindings.json"

# copy the settings over to the file
# overriding the setting file

print success "save the current settings"
echo "$(cat $settings)" > "$settings_file"

# echo "$settings"
# echo "$(cat $settings)"

print success "save the current keybinds"
echo "$(cat $keybindings)" > "$keybinds_file"
