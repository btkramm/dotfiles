#!/bin/bash

# https://yazi-rs.github.io/docs/quick-start/#shell-wrapper

function y() {
  local tmp

  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

  yazi "$@" --cwd-file="$tmp"

  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd" || exit
  fi

  rm -f -- "$tmp"
}
