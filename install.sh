#!/bin/bash

# Homebrew --------------------------------------------------------------------

if ! command -v "brew" &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo 'Command "brew" is already installed.'
fi

# Kitty -----------------------------------------------------------------------

if ! command -v "kitty" &> /dev/null; then
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
else
  echo 'Command "kitty" is already installed.'
fi

# Zsh -------------------------------------------------------------------------

brew install zsh-autosuggestions # zsh-autosuggestions
brew install zsh-syntax-highlighting # zsh-syntax-highlighting
brew install zsh-vi-mode # zsh-vi-mode

# yabai & skhd & JankyBorders -------------------------------------------------

brew install koekeishiya/formulae/yabai # yabai
brew install koekeishiya/formulae/skhd # skhd

brew install FelixKratz/formulae/borders # JankyBorders

# Python ----------------------------------------------------------------------

brew install pipx

# Ruby ------------------------------------------------------------------------

brew install rbenv ruby-build # rbenv

# NeoVim ----------------------------------------------------------------------

brew install neovim # neovim

brew install luarocks # luarocks

# Miscellaneous ---------------------------------------------------------------

brew install ansible # ansible
brew install bat # bat
brew install btop # btop
brew install cloc # cloc
brew install coreutils # GNU coreutils
brew install direnv # direnv
brew install dust # dust
brew install eza # eza
brew install fd # fd
brew install fnm # fnm
brew install fzf # fzf
brew install gh # gh
brew install git-delta # delta
brew install git-lfs # lfs
brew install graphviz # graphviz
brew install jq # jq
brew install nmap # nmap
brew install restic # restic
brew install ripgrep # ripgrep
brew install smudge/smudge/nightlight # nightlight
brew install tldr # tldr
brew install unzip # unzip
brew install wget # wget
brew install yazi # yazi
brew install zip # zip
brew install zoxide # zoxide
