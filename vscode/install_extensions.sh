echo "Installing Visual Studo Code extenstions"

for extension in $(cat extensions)
do
	echo "Installing or update : ${extension}"
	code --install-extension $extension
done

# create a symlick file to get the update in sink instade of copying
os=$(uname)

echo "--copy settings.json and keybindings.json for VScode"
if [ "$os" == "Darwin" ]; then
	echo -e "setting loc for $os: "
	cp -f keybindings.json $HOME/Library/Application Support/Code/User/keybindings.json
	cp -f settings.json  $HOME/Library/Application Support/Code/User/settings.json
elif [ "$os" == "Linux" ]; then
	echo -e "setting loc for $os: "
	cp -f keybindings.json /mnt/c/Users/kiyam/AppData/Roaming/Code/User/keybindings.json
	cp -f settings.json /mnt/c/Users/kiyam/AppData/Roaming/Code/User/settings.json
else
	echo "system not indentified"
fi

