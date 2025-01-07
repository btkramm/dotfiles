PS1="%n %1~ %# "

# zsh-vi-mode -----------------------------------------------------------------

ZVM_INIT_MODE=sourcing

ZVM_VI_SURROUND_BINDKEY="s-prefix"

source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

function zvm_after_init() {
  # History navigation
  
  bindkey -M vicmd 'n' down-line-or-history
  bindkey -M vicmd 'N' up-line-or-history

  # Horizontal movement

  bindkey -M vicmd 'H' beginning-of-line
  bindkey -M vicmd 'L' end-of-line
}

# Modules ---------------------------------------------------------------------

source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/aliases.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/android.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/direnv.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/fintual.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/flutter.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/fzf.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/nvm.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/zoxide.sh

# zsh-syntax-highlighting -----------------------------------------------------

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
