# Claude Code's hooks run `workmux set-window-status` to report agent state,
# which needs to invoke `kitten` (inside the kitty application bundle) to list
# panes and persist state for `wm dashboard`. Without read-only access to the
# kitty application bundle and the kitty environment variables passed through,
# `workmux` silently fails and the dashboard stays empty.

KITTY_INSTALLATION_CONTENTS_DIR="${KITTY_INSTALLATION_DIR%/Contents/*}"

SAFEHOUSE_ADD_DIRS="$CLAUDE_CONFIG_DIR"
SAFEHOUSE_ADD_DIRS_RO="$KITTY_INSTALLATION_CONTENTS_DIR"
SAFEHOUSE_APPEND_PROFILE="$XDG_CONFIG_HOME/agent-safehouse/local-overrides.sb"
SAFEHOUSE_ENV_PASS="CLAUDE_CONFIG_DIR,KITTY_PID,KITTY_LISTEN_ON,KITTY_INSTALLATION_DIR,KITTY_WINDOW_ID,KITTY_PUBLIC_KEY"

safe() {
  local add_dirs="$SAFEHOUSE_ADD_DIRS"
  local add_dirs_ro="$SAFEHOUSE_ADD_DIRS_RO"

  # In bare-repository + worktree configurations the `git` metadata directory
  # lives outside the working tree. Resolve it dynamically so the sandbox can
  # access it.

  local git_common_dir

  git_common_dir="$(pwr 2> /dev/null)"

  if [[ -n $git_common_dir ]]; then
    add_dirs="$add_dirs:$git_common_dir"
  fi

  safehouse \
    --add-dirs="$add_dirs" \
    --add-dirs-ro="$add_dirs_ro" \
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
