export XDG_CONFIG_HOME="$HOME/.config"

export ZDOTDIR="$HOME/.config/zsh"

export DOTDIR="$(dirname "$(dirname "$(dirname "$(realpath "${(%):-%x}")")")")"

export HISTSIZE=10000
export SAVEHIST=10000

export EDITOR="nvim"
export VISUAL="nvim"

export MANPAGER='nvim +Man!'

[[ -f "$ZDOTDIR/modules/secrets.sh" ]] && source "$ZDOTDIR/modules/secrets.sh"

# Claude Code

export CLAUDE_CONFIG_DIR="$HOME/.config/claude"

# Meilisearch

export MEILI_CONFIG_FILE_PATH="$HOME/.config/meilisearch/meilisearch.toml"
