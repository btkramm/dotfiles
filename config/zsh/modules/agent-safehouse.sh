SAFEHOUSE_ADD_DIRS="$CLAUDE_CONFIG_DIR"
SAFEHOUSE_APPEND_PROFILE="$XDG_CONFIG_HOME/agent-safehouse/local-overrides.sb"
SAFEHOUSE_ENV_PASS="ANTHROPIC_API_KEY,CLAUDE_CONFIG_DIR,EDITOR,KITTY_LISTEN_ON,KITTY_WINDOW_ID,MEILI_HOST,MEILI_MASTER_KEY,TERMINFO"

safe() {
  safehouse \
    --add-dirs="$SAFEHOUSE_ADD_DIRS" \
    --append-profile="$SAFEHOUSE_APPEND_PROFILE" \
    --enable=ssh \
    --env-pass="$SAFEHOUSE_ENV_PASS" \
    "$@"
}

safe-claude() {
  safe claude --dangerously-skip-permissions "$@"
}

unsafe-claude() {
  claude --dangerously-skip-permissions "$@"
}
