export ZDOTDIR="$HOME/.config/zsh"

export HISTSIZE=10000
export SAVEHIST=10000

export EDITOR="nvim"
export VISUAL="nvim"

[[ -f "$ZDOTDIR/modules/secrets.sh" ]] && source "$ZDOTDIR/modules/secrets.sh"
