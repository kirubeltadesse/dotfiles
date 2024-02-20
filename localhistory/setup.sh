source "$HOME"/.dotfiles/utility/utilities.sh

filebashrc="$HOME/.bashrc"
text="
source $HOME/.dotfiles/localhistory/pass_completion.sh 
complete -o filenames -F _pass pass
"

print warning "Adding bash complete for pass to .bashrc"

while IFS= read -r line; do
	append_line 1 "${line}" "${filebashrc}"
done <<< "$text"



