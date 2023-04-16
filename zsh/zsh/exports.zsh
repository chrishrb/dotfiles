#!/bin/zsh
export PATH="/Users/cherb/jam-dev/work/cris/vws2-credentials-loader:$PATH"
export PATH="/Users/cherb/jam-dev/work/cris/vcl:$PATH"

# sdkman
export SDKMAN_DIR="/Users/cherb/.sdkman"
[[ -s "/Users/cherb/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/cherb/.sdkman/bin/sdkman-init.sh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/cherb/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/cherb/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/cherb/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/cherb/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="/Users/cherb/.rd/bin:$PATH"
export CDK_DOCKER=podman
