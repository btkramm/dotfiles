#!/bin/bash

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# and follow post-install instructions
#
# Install Kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# GitHub CLI

brew install gh

# Z
brew install z

# NeoVim
brew install neovim

# direnv
brew install direnv

# RVENV
brew install rbenv ruby-build


# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Coreutils
brew install coreutils



for file in shell/*
do
  fullpath=$(realpath "$file")

  source="source $fullpath"

  if grep -q "$source" ~/.zshrc; then
    echo "$source already installed"
  else
    read -r -p "Source $file? (Y/n): " response

    if [ -z "$response" ] || [ "$response" = "y" ]; then
      echo "$source" >> ~/.zshrc
    fi
  fi
done

for from in config/*
do
  from_fullpath=$(realpath "$from")
  to_fullpath="$HOME/.$from"

  if ! [ -e "$to_fullpath" ]; then
    ln -s "$from_fullpath" "$to_fullpath"
  fi
done

