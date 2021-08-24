time_out () { perl -e 'alarm shift; exec @ARGV' "$@"; }

echo "Checking for updates."
({cd ~/dotfiles && git fetch -q} &> /dev/null)
 
if [ $({cd ~/dotfiles} &> /dev/null && git rev-list HEAD...origin/main | wc -l) = 0 ]
then
	echo "Already up to date."
else
	echo "Updates Detected:"
	({cd ~/dotfiles} &> /dev/null && git log ..@{u} --pretty=format:%Cred%aN:%Creset\ %s\ %Cgreen%cd)
	echo "Setting up..."
	({cd ~/dotfiles} &> /dev/null && git pull -q && git submodule update --init --recursive)
fi

source ~/dotfiles/zsh/zshrc

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/cherb/.sdkman"
[[ -s "/Users/cherb/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/cherb/.sdkman/bin/sdkman-init.sh"

export SENCHA_EXECUTABLE=/opt/Sencha/Cmd/sencha

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
