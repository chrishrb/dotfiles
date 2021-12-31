#!/bin/bash

UPSTREAM=${1:-'@{u}'}

echo "Checking for updates."
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
    echo "Up-to-date"
elif [ $LOCAL = $BASE ]; then
    echo "Updates Detected:"
    git --no-pager log ..@{u} --pretty=format:%Cred%aN:%Creset\ %s\ %Cgreen%cd

    echo "Setting up..."
    git pull -q && git submodule update --init --recursive

    echo "Now up-to-date"
elif [ $REMOTE = $BASE ]; then
    echo "Need to push"
else
    echo "Diverged"
fi
