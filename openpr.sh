#!/usr/bin/env bash

## Usage: openpr [base-branch]
## Opens a browser window to the Create Pull Request page for the branch that is currently checked out. If the base branch is specified, then it will open the PR draft with that branch as the base. Otherwise, the base will be the repo's default (typically master).

## Installation with AutoComplete:
## - Download git-completion.bash
## - Add `openpr = "!f() { : git switch ; sh /path/to/openpr.sh $1; }; f"` to git config (without the backticks)

DIR="$(git remote get-url origin)"
REPO=${DIR#git@github.com:}
REPO=${REPO%.git}
BRANCH="$(git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
BASE=""

if [[ -n $1 ]]; then
  BASE="$1..."
fi

if [[ -z REPO ]] || [[ -z BRANCH ]]; then
  echo "Invalid repo or current branch name - are you in a git directory?"
else
  open "https://github.com/$REPO/compare/$BASE$BRANCH?expand=1"
fi
