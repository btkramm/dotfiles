SAFEHOUSE_ADD_DIRS="$CLAUDE_CONFIG_DIR"
SAFEHOUSE_APPEND_PROFILE="$XDG_CONFIG_HOME/agent-safehouse/local-overrides.sb"
SAFEHOUSE_ENV_PASS="CLAUDE_CONFIG_DIR,EDITOR,KITTY_LISTEN_ON,KITTY_WINDOW_ID,MEILI_HOST,MEILI_MASTER_KEY,TERMINFO"

safe() {
  local add_dirs="$SAFEHOUSE_ADD_DIRS"

  # In bare-repository + worktree configurations the `git` metadata directory
  # lives outside the working tree. Resolve it dynamically so the sandbox can
  # access it.

  local git_common_dir

  git_common_dir="$(pwr 2> /dev/null)"

  if [[ -n $git_common_dir ]]; then
    add_dirs="$add_dirs:$(dirname "$git_common_dir")"
  fi

  safehouse \
    --add-dirs="$add_dirs" \
    --append-profile="$SAFEHOUSE_APPEND_PROFILE" \
    --env-pass="$SAFEHOUSE_ENV_PASS" \
    "$@"
}

safe-claude() {
  safe claude --dangerously-skip-permissions "$@"
}

unsafe-claude() {
  claude --dangerously-skip-permissions "$@"
}
