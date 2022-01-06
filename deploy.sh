#!/bin/bash

DOTFILES_DIR=$(git rev-parse --show-toplevel)

# {{{util func
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

check_for_sdkman() {
	echo "Checking to see if sdkman is installed"
	FILE=$HOME/.sdkman/bin/sdkman-init.sh
	if ! [ -f "$FILE" ]; then
		echo -n "sdkman is not installed. Would you like to install it? (y/n) " >&2
		old_stty_cfg=$(stty -g)
		stty raw -echo
		answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
		stty $old_stty_cfg && echo
		if echo "$answer" | grep -iq "^y" ;then
			curl -s "https://get.sdkman.io?rcupdate=false" | bash
		fi
	else
		echo "sdkman is installed."
	fi
}

check_for_basictex() {
	echo "Checking to see if basictex is installed"
	if ! [ -x "$(command -v latexmk)" ]; then
		echo -n "basictex is not installed. Would you like to install it? (y/n) " >&2
		old_stty_cfg=$(stty -g)
		stty raw -echo
		answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
		stty $old_stty_cfg && echo
		if echo "$answer" | grep -iq "^y" ;then
		  if [ -x "$(command -v brew)" ]; then
        # install tex
        brew install --cask basictex
        eval "$(/usr/libexec/path_helper)"

        # update
        sudo tlmgr update --self && sudo tlmgr update --all

        # install font
        curl https://www.tug.org/fonts/getnonfreefonts/install-getnonfreefonts > /tmp/install-getnonfreefonts
        sudo texlua /tmp/install-getnonfreefonts
        sudo getnonfreefonts --sys -a

        # install dependencies
        sudo tlmgr install latexmk ucs sectsty apacite titling blindtext todonotes texcount
      else
        echo "Brew not installed or you are not on mac env. Please install basictex manually."
      fi
		fi
	else
		echo "basictex is installed."
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
		check_for_software nvim ripgrep
		setup_symlink nvim/lua .config/nvim/lua
		setup_symlink nvim/init.lua .config/nvim/init.lua
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
    check_for_software gawk coreutils
    # system specific
		if [ -x "$(command -v brew)" ]; then
      check_for_software reattach-to-user-namespace
    else
      check_for_software net-tools
    fi
    setup_symlink tmux/tmux.conf .tmux.conf
} #}}}

setup_tmuxinator() { #{{{
  check_for_software tmuxinator
  setup_symlink tmuxinator/config .config/tmuxinator
} # }}}

setup_latex() { #{{{
  check_for_basictex
} # }}}

setup_software() { #{{{
		check_for_sdkman
    check_for_software rust
    check_for_software go
} #}}}

setup_dotfiles() { #{{{
		echo "Setup ideavimrc"
		setup_symlink idea/ideavimrc .ideavimrc

		echo "Set Git Config and Aliases"
		git config --global include.path "$DOTFILES_DIR/zsh/gitconfig"
} #}}}

setup_kitty() { #{{{
		setup_symlink kitty .config/kitty
} #}}}

git submodule update --init --recursive

if [ "$1" = 'dotfiles' ]; then
    setup_dotfiles
    echo "dotfiles ready"
elif [ "$1" = 'kitty' ]; then
    setup_kitty
    echo "kitty ready"
elif [ "$1" = 'keyboard' ]; then
    echo "Install https://github.com/MickL/macos-keyboard-layout-german-programming"
elif [ "$1" = 'zsh' ]; then
    setup_zsh
		echo "Please log out and log back in for default shell to be initialized."
elif [ "$1" = 'tmux' ]; then
    setup_tmux
    echo "tmux ready"
elif [ "$1" = 'tmuxinator' ]; then
    setup_tmuxinator
    echo "tmuxinator ready"
elif [ "$1" = 'nvim' ]; then
    setup_nvim
    echo "nvim ready"
elif [ "$1" = 'latex' ]; then
    setup_latex
    echo "latex ready"
elif [ "$1" = 'software' ]; then
    setup_software
    echo "all software ready"
else
		echo "Command not found"
fi
