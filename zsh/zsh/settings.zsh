#!/bin/zsh

# env
export EDITOR="nvim"

# Go, Rust, ruby
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/lib/ruby/gems/3.0.0/bin:$PATH"
export PATH="$HOME/bin/jdt-language-server-1.9.0-202203031534/bin:$PATH"

export GOPATH="$HOME/golang"
export GOROOT="/opt/homebrew/opt/go/libexec"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$GOROOT/bin"

# increase speed in git repos
RPROMPT=''
DISABLE_UNTRACKED_FILES_DIRTY="true"

# fzf options
export FZF_DEFAULT_OPTS="
--layout=reverse
--info=inline
--height=80%
--multi
--preview-window=:hidden
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
--bind '?:toggle-preview'
--bind 'ctrl-a:select-all'
--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
--bind 'ctrl-e:execute(echo {+} | vim -)'
--bind 'ctrl-k:up,ctrl-j:down'
"

# direnv
eval "$(direnv hook zsh)"
