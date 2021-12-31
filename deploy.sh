#!/bin/bash

DOTFILES_DIR=$(git rev-parse --show-toplevel)

# Util Func{{{
prompt_install() {
	echo -n "$1 is not installed. Would you like to install it? (y/n) " >&2
	old_stty_cfg=$(stty -g)
	stty raw -echo
	answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
	stty $old_stty_cfg && echo
	if echo "$answer" | grep -iq "^y" ;then
		# This could def use community support
		if [ -x "$(command -v apt-get)" ]; then
			sudo apt-get install $1 -y

		elif [ -x "$(command -v brew)" ]; then
			brew install $1

		elif [ -x "$(command -v pkg)" ]; then
			sudo pkg install $1

		elif [ -x "$(command -v pacman)" ]; then
			sudo pacman -S $1

		else
			echo "I'm not sure what your package manager is! Please install $1 on your own and run this deploy script again. Tests for package managers are in the deploy script you just ran starting at line 13." 
		fi 
	fi
}

check_for_software() {
	echo "Checking to see if $1 is installed"
	if ! [ -x "$(command -v $1)" ]; then
		prompt_install $1
	else
		echo "$1 is installed."
	fi
}

check_default_shell() {
	if [ -z "${SHELL##*zsh*}" ] ;then
			echo "Default shell is zsh."
	else
		echo -n "Default shell is not zsh. Do you want to chsh -s \$(which zsh)? (y/n)"
		old_stty_cfg=$(stty -g)
		stty raw -echo
		answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
		stty $old_stty_cfg && echo
		if echo "$answer" | grep -iq "^y" ;then
			chsh -s $(which zsh)
		else
			echo "Warning: Your configuration won't work properly. If you exec zsh, it'll exec tmux which will exec your default shell which isn't zsh."
		fi
	fi
}

# $1 FROM, $2 TO
setup_symlink() {
    if [[ "$2" == *"/"* ]]; then
        DIR=$(echo "$2" | grep -o ".*\/")
        mkdir -p "$HOME/$DIR"
    fi
    ln -sf "$DOTFILES_DIR/$1" "$HOME/$2"
}

# $1 FROM, $2 TO
setup_copy() {
    if [[ "$2" == *"/"* ]]; then
        DIR=$(echo "$2" | grep -o ".*\/")
        mkdir -p "$HOME/$DIR"
    fi
    cp -rf "$DOTFILES_DIR/$1" "$HOME/$2"
}
#}}}

setup_nvim() { #{{{
		check_for_software nvim

} #}}}

setup_zsh() { #{{{
		check_for_software zsh
		check_for_software fzf
		if ! [ -x "$(command -v fzf)" ]; then
				/usr/local/opt/fzf/install
		fi
		check_for_software xclip
		setup_symlink zsh/zshrc .zshrc
		check_default_shell
} #}}}

setup_tmux() { #{{{
		check_for_software tmux
} #}}}

setup_programms() { #{{{
		echo "empty"

} #}}}

setup_dotfiles() { #{{{
		echo "Setup ideavimrc"
		setup_symlink idea/ideavimrc .ideavimrc

		echo "Set Git Config and Aliases"
		git config --global include.path "$DOTFILES_DIR/zsh/gitconfig"
} #}}}


git submodule update --init --recursive

if [ "$1" = 'dotfiles' ]; then
    setup_dotfiles
elif [ "$1" = 'zsh' ]; then
    setup_zsh
		echo "Please log out and log back in for default shell to be initialized."
elif [ "$1" = 'tmux' ]; then
    setup_tmux
elif [ "$1" = 'vim' ]; then
    setup_nvim
fi
