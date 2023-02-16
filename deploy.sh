#!/bin/bash

DOTFILES_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# {{{util func
prompt_install() { #{{{
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
} #}}}

check_for_sdkman() { #{{{
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
} #}}}

check_for_cask() { # {{{
	echo "Checking to see if cask $1 is installed"
  if brew list --cask $1 &>/dev/null; then
		echo "$1 is installed"
  else
		echo -n "$1 is not installed. Would you like to install it? (y/n) " >&2
		old_stty_cfg=$(stty -g)
		stty raw -echo
		answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
		stty $old_stty_cfg && echo
		if echo "$answer" | grep -iq "^y" ; then
		  if [ -x "$(command -v brew)" ]; then
        brew install --cask $1 && echo "$1 is installed"
      else
        echo "Brew not installed or you are not on mac env. Please install $1 manually."
      fi
		fi
	fi
} #}}}

check_for_software() { #{{{
	echo "Checking to see if $1 is installed"
  if [ -z "$2" ]; then
    COMMAND=$1
  else
    COMMAND=$2
  fi

	if ! [ -x "$(command -v $COMMAND)" ]; then
		prompt_install $1
	else
		echo "$1 is installed."
	fi
} #}}}

check_default_shell() { #{{{
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
} #}}}

# $1 FROM, $2 TO
setup_symlink() {
  # create dir structure
  if [[ "$2" == *"/"* ]]; then
      DIR=$(dirname $HOME/$2)
      mkdir -p "$HOME/$DIR"
  fi

  ln -nsf "$DOTFILES_DIR/$1" "$HOME/$2"
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
  check_for_software "neovim --HEAD"  
  check_for_software ripgrep
  setup_symlink nvim .config/nvim
} #}}}

setup_zsh() { #{{{
  check_for_software zsh
  check_for_software fzf
  check_for_software direnv
  if ! [ -x "$(command -v fzf)" ]; then
      /usr/local/opt/fzf/install
  fi
  setup_symlink zsh/zshrc .zshrc
  setup_symlink zsh/zsh/ .config/zsh
  check_default_shell
} #}}}

setup_tmux() { #{{{
  check_for_software tmux
  check_for_software tmuxinator
  check_for_software gawk coreutils
  # system specific
  if [ -x "$(command -v brew)" ]; then
    check_for_software reattach-to-user-namespace
  else
    check_for_software net-tools
  fi
  setup_symlink tmux/tmux.conf .tmux.conf
  setup_symlink tmuxinator/config .config/tmuxinator
  git clone https://github.com/catppuccin/alacritty.git ~/.config/alacritty/catppuccin
  echo "Press prefix (CTRL+A) + I to install all plugins"
} #}}}

setup_latex() { #{{{
  check_for_cask basictex

  eval "$(/usr/libexec/path_helper)"

  # update
  sudo tlmgr update --self && sudo tlmgr update --all

  # install font
  curl https://www.tug.org/fonts/getnonfreefonts/install-getnonfreefonts > /tmp/install-getnonfreefonts
  sudo texlua /tmp/install-getnonfreefonts
  sudo getnonfreefonts --sys -a

  # install dependencies
  sudo tlmgr install latexmk ucs sectsty apacite titling blindtext todonotes texcount soul
} # }}}

setup_software() { #{{{
  check_for_sdkman
  check_for_software ruby@3.0
  check_for_software htop
  check_for_software wget
  check_for_software python@3.10
  check_for_software rustup
  check_for_software go
  check_for_software jq
  check_for_software node
  check_for_software tree
  check_for_software youtube-dl
  check_for_software ffmpeg
  check_for_software neofetch
  check_for_software s-search s
  check_for_software watchman
  check_for_software ghostscript gs
  check_for_software aws awscli
  check_for_software cloud-nuke
  # check_for_software tfenv
  # check_for_software tgenv
  check_for_software imagemagick
  check_for_software poetry
  check_for_software cookiecutter

  if ! [ -x "$(command -v timetrap)" ]; then
    sudo gem install timetrap
  fi

  # provide public url for locally running server
  # check_for_software ngrok

  check_for_cask utm

  # s-search config
  setup_symlink s .config/s

  # for youtube dl
  mkdir -p ~/Music/youtube/
  mkdir -p ~/Video/youtube/
} #}}}

setup_dotfiles() { #{{{
  echo "Setup ideavimrc"
  setup_symlink idea/ideavimrc .ideavimrc

  echo "Set Git Config and Aliases"
  git config --global include.path "$DOTFILES_DIR/zsh/gitconfig"
  git config --global core.excludesfile "$DOTFILES_DIR/zsh/gitignore"
} #}}}

setup_alacritty() { #{{{
  check_for_cask alacritty
  setup_symlink alacritty .config/alacritty
  echo "Install icon here: https://github.com/k0nserv/kitty-icon"
} #}}}

setup_mac() { #{{{
  # brew
  echo "check if brew is installed.."
  if ! [ -x "$(command -v brew)" ]; then
    echo "install brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "brew is installed"
  fi

  check_for_cask notion
  check_for_cask scroll-reverser
  check_for_cask tiles
  check_for_cask discord
  check_for_software coreutils
  check_for_cask spotify
  check_for_cask slack
  check_for_cask zoom
  # check_for_cask font-fira-code
  echo "Install font manually"
  check_for_cask bitwarden
  check_for_software rancher
  check_for_software speedtest-cli
  check_for_cask vivaldi

  # macos specific setup
  source $DOTFILES_DIR/mac/macos.sh

  # setup keyboard
  echo "Setup Keyboard"
  echo "Install https://github.com/MickL/macos-keyboard-layout-german-programming"
} #}}}

setup_yabai() { #{{{
  # yabai - tiling window manager
  echo "Install yabai"
  echo -n "Disable System Integrity Protection first!! Done (y/n)? "
  read answer
  if [ "$answer" != "${answer#[Yy]}" ] ;then
    check_for_software yabai
    check_for_software skhd
    setup_symlink mac/yabai .config/yabai
    setup_symlink mac/skhd .config/skhd

    echo "Install and test yabai"
    echo "https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)"
  else
    echo "https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection"
    exit 1
  fi
} # }}}

setup_flutter() { #{{{
  check_for_cask flutter
  check_for_cask android-commandlinetools
  flutter config --android-sdk /opt/homebrew/share/android-commandlinetools
  sdkmanager --install "cmdline-tools;latest"
  sdkmanager "build-tools;32.0.0" "platform-tools" "platforms;android-32"
  flutter doctor --android-licenses
  echo "Install xcode manually over the AppStore oder under https://developer.apple.com/download/all/"
  sudo gem install cocoapods
  flutter doctor
} #}}}

setup_rust() { #{{{
	if ! [ -x "$(command -v 'rustup')" ]; then
    echo "installing rust.."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	else
		echo "rust and all utilities are installed."
	fi
  check_for_software 'rust-analyzer'
} #}}}

git submodule update --init --recursive

if [ "$1" = 'dotfiles' ]; then
  setup_dotfiles
  echo "dotfiles ready"
elif [ "$1" = 'mac' ]; then
  setup_mac
  echo "mac ready"
elif [ "$1" = 'alacritty' ]; then
  setup_alacritty
  echo "alacritty ready"
elif [ "$1" = 'zsh' ]; then
  setup_zsh
  echo "Please log out and log back in for default shell to be initialized."
elif [ "$1" = 'tmux' ]; then
  setup_tmux
  echo "tmux ready"
elif [ "$1" = 'yabai' ]; then
  setup_yabai
  echo "yabai ready"
elif [ "$1" = 'nvim' ]; then
  setup_nvim
  echo "nvim ready"
elif [ "$1" = 'latex' ]; then
  setup_latex
  echo "latex ready"
elif [ "$1" = 'software' ]; then
  setup_software
  echo "all software ready"
elif [ "$1" = 'flutter' ]; then
  setup_flutter
  echo "flutter ready"
elif [ "$1" = 'rust' ]; then
  setup_rust
  echo "rust ready"
else
  echo "Command not found! Valid commands are: "
  echo "  dotfiles"
  echo "  mac"
  echo "  kitty"
  echo "  zsh"
  echo "  nvim"
  echo "  tmux"
  echo "  yabai"
  echo "  latex"
  echo "  flutter"
  echo "  rust"
fi
