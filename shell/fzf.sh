source <(fzf --zsh)

export FZF_DEFAULT_COMMAND='fd --type f'

export FZF_CTRL_T_COMMAND='fd --type f'
export FZF_CTRL_T_OPTS='--walker-skip .git,node_modules'

export FZF_ALT_C_COMMAND='fd --type d'
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules --preview 'tree -C {}'"
