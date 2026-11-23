#!/bin/bash

set -u

input="$1"
config="$(dirname "$0")/mermaid-config.json"

# config/zsh/modules/fintual.sh points Puppeteer at a system chromium that may
# not exist; mermaid-cli must use the chrome-headless-shell it pins instead.
unset PUPPETEER_EXECUTABLE_PATH PUPPETEER_SKIP_CHROMIUM_DOWNLOAD

tmp_dir=$(mktemp -d)

trap 'rm -rf "$tmp_dir"' EXIT

png="$tmp_dir/diagram.png"

# Rendering -------------------------------------------------------------------

pane_pixels() {
  python3 -c '
import fcntl, struct, termios
rows, _, width, height = struct.unpack("HHHH", fcntl.ioctl(0, termios.TIOCGWINSZ, b"\0" * 8))
print(max(width, height * (rows - 1) // rows) if rows and width and height else 0)
' 2> /dev/null || echo 0
}

# --size fixes the PNG's longer side, so asking for the pane's longer side in
# pixels leaves chafa only ever shrinking the image, never enlarging it.
pixels=$(pane_pixels)

if [ "$pixels" -gt 0 ]; then
  sizing=(--size "$pixels")
else
  sizing=(-s 3)
fi

printf 'Rendering %s…' "$(basename "$input")"

if ! mmdc -q -i "$input" -o "$png" -c "$config" -b transparent "${sizing[@]}" 2> "$tmp_dir/error"; then
  printf '\r\033[K\033[31mmmdc could not render the diagram:\033[0m\n\n'
  grep -v '^    at ' "$tmp_dir/error"
  printf '\nPress any key to close.'
  read -rsn1

  exit 1
fi

# Drawing ---------------------------------------------------------------------

draw() {
  local cols lines

  cols=$(tput cols)
  lines=$(tput lines)

  # Kitty images outlive a screen clear, so delete them explicitly.
  printf '\033_Ga=d,d=A\033\\\033[2J\033[H'

  chafa -f kitty --scale max --align mid,mid --size "${cols}x$((lines - 1))" "$png"

  printf '\033[%d;1H\033[2mq close\033[0m' "$lines"
}

trap draw WINCH

draw

while true; do
  IFS= read -rsn1 key
  status=$?

  # A WINCH interrupts read with a status above 128; anything else is EOF.
  if [ "$status" -gt 128 ]; then continue; fi

  if [ "$status" -ne 0 ]; then break; fi

  case "$key" in
    q | Q | $'\e' | '') break ;;
  esac
done
