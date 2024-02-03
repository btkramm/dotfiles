#!/bin/bash

git branch --format="%(refname:short)" \
  | fzf --ansi --height=~100% --reverse \
  | xargs git switch
