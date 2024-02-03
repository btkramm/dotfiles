setopt PROMPT_SUBST

get_prompt() {
  if ! git rev-parse --git-dir &> /dev/null || [ "$(git rev-parse --is-bare-repository)" = "true" ]; then
    echo "%n %2~"

    return
  fi

  git_dir=$(git rev-parse --git-dir)

  branch_name=$(git branch --show-current)

  if [ -z "$branch_name" ]; then
    commit_hash=$(git rev-parse --short HEAD 2> /dev/null)

    branch_name="%F{red}detached:$commit_hash%f"
  else
    branch_name="%F{cyan}$branch_name%f"
  fi

  if [ -f "$git_dir/BISECT_START" ]; then
    bisect=" (%F{yellow}bisect%f)"
  else
    bisect=""
  fi

  parent_dirname=$(basename "$(dirname "$git_dir")")

  if [ "$parent_dirname" = "worktrees" ]; then
    worktree_name=$(basename "$git_dir")

    echo "%n %2~ [%F{magenta}$worktree_name%f/$branch_name]$bisect"

    return
  fi

  echo "%n %2~ [$branch_name]$bisect"

  return
}

PS1_NEWLINE=$'\n'
PS1='$(get_prompt)${PS1_NEWLINE}⏵ '

export PATH="/opt/homebrew/bin:$PATH"

# compinit --------------------------------------------------------------------

autoload -Uz compinit && compinit

# zsh-vi-mode -----------------------------------------------------------------

ZVM_VI_SURROUND_BINDKEY="s-prefix"

source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

function zvm_after_init() {
  zvm_bindkey vicmd 'H' beginning-of-line
  zvm_bindkey vicmd 'L' end-of-line

  # fzf -----------------------------------------------------------------------

  source $(brew --prefix)/opt/fzf/shell/completion.zsh
  source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh
}

# /modules/ -------------------------------------------------------------------

source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/aliases.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/android.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/direnv.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/fintual.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/flutter.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/fnm.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/fzf.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/yazi.sh
source /Users/btkramm/personal/dotfiles/main/config/zsh/modules/zoxide.sh

# zsh-autosuggestions -----------------------------------------------------

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting -----------------------------------------------------

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# pipx

export PATH="$PATH:/Users/btkramm/.local/bin"
