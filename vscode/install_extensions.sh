echo "Installing Visual Studo Code extenstions"

for extension in $(cat extensions)
do 
    echo "Installing: ${extension}"
    code --install-extension $extension
done

echo "--Installing Keyboarding.json for VScode"
# FIXME: automatic get the destination location
# create a symlick file to get the update in sink instade of copying

cp -f keybindings.json /c/Users/$USER/AppData/Roaming/Code/User/keybindings.json


# echo "--Adding settings.json for VScode"
# cp -f settings.json /c/Users/$USER/AppData/Roaming/Code/User/settings.json


