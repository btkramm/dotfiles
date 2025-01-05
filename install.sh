#!/bin/bash

# Homebrew

if ! command -v "brew" &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Command \"brew\" is already installed."
fi

brew install bat # bat
brew install btop # btop
brew install direnv # direnv
brew install eza # eza
brew install fd # fd
brew install fzf # fzf
brew install jq # jq
brew install luarocks # luarocks
brew install neovim # neovim
brew install nmap # nmap
brew install ripgrep # ripgrep
brew install tldr # tldr
brew install unzip # unzip
brew install wget # wget
brew install zip # zip
brew install zoxide # zoxide
brew install zsh-syntax-highlighting # zsh-syntax-highlighting

# GitHub CLI

brew install gh # gh
gh extension install dlvhdr/gh-dash # gh-dash

# MacOS

# - Kitty

if ! command -v "kitty" &> /dev/null; then
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
else
  echo "Command \"kitty\" is already installed."
fi

brew install coreutils # GNU coreutils
brew install koekeishiya/formulae/skhd # skhd
brew install koekeishiya/formulae/yabai # yabai

# Node.js

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash # nvm

# Ruby

brew install rbenv ruby-build # rbenv
