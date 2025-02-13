source "../utility/utilities.sh"
echo "Installing Visual Studo Code extenstions"

for extension in $(cat extensions); do
	print warning "Installing or update : ${extension}"
	code --install-extension "$extension"
done

# create a symlick file to get the update in sink instade of copying
os=$(uname)

print warning "--copy settings.json and keybindings.json for VScode"
if [ "$os" == "Darwin" ]; then
	print warning "setting loc for ${os}: "
	# TODO: make smart update instead of direct swap
	cp -f keybindings.json "$HOME"/Library/Application\ Support/Code/User/keybindings.json
	cp -f settings.json "$HOME"/Library/Application\ Support/Code/User/settings.json
elif [ "$os" == "Linux" ]; then
	print warning "setting loc for ${os}: "
	cp -f keybindings.json /mnt/c/Users/kiyam/AppData/Roaming/Code/User/keybindings.json
	cp -f settings.json /mnt/c/Users/kiyam/AppData/Roaming/Code/User/settings.json
else
	print error "system not indentified"
fi
