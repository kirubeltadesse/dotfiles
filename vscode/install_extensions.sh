echo "Installing Visual Studo Code extenstions"

for extension in $(cat extensions)
do 
    echo "Installing: ${extension}"
    code --install-extension $extension
done

echo "--Installing Keyboarding.json for VScode"
# FIXME: automatic get the destination location
# create a symlick file to get the update in sink instade of copying


echo "--copy settings.json and keybindings.json for VScode"
if [ "$os" == "Darwin" ]; then
	echo -e "setting loc for $os: "
	cp -f keybindings.json $HOME/Library/Application Support/Code/User/keybindings.json
	cp -f settings.json  $HOME/Library/Application Support/Code/User/settings.json
elif [ "$os" == "Linux" ]; then
	echo -e "setting loc for $os: "
	cp -f keybindings.json /mnt/c/Users/kiyam/AppData/Roaming/Code/User/keybindings.json
	cp -f keybindings.json /mnt/c/Users/kiyam/AppData/Roaming/Code/User/keybindings.json
else 
	echo "system not indentified"
fi

