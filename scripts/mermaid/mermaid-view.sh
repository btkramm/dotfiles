#!/bin/bash

set -u

input="$1"
config="$(dirname "$0")/mermaid-config.json"

# `fintual.sh` points Puppeteer at a chromium that can be missing. `mmdc` needs
# the `chrome-headless-shell` that it pins.
unset PUPPETEER_EXECUTABLE_PATH PUPPETEER_SKIP_CHROMIUM_DOWNLOAD

tmp_dir=$(mktemp -d)

trap 'rm -rf "$tmp_dir"' EXIT

png="$tmp_dir/diagram.png"
error_log="$tmp_dir/error.log"

# Rendering -------------------------------------------------------------------

pane_pixels() {
  python3 -c '
import fcntl, struct, termios
rows, _, width, height = struct.unpack("HHHH", fcntl.ioctl(0, termios.TIOCGWINSZ, b"\0" * 8))
print(max(width, height * (rows - 1) // rows) if rows and width and height else 0)
' 2> /dev/null || echo 0
}

# `--size` sets the longer side of the PNG. When it is the longer side of the
# pane, `chafa` only makes the image smaller.
pixels=$(pane_pixels)

if [ "$pixels" -gt 0 ]; then
  sizing=(--size "$pixels")
else
  sizing=(--scale 3)
fi

printf 'Rendering %s…' "$(basename "$input")"

if ! mmdc -q -i "$input" -o "$png" -c "$config" -b transparent "${sizing[@]}" 2> "$error_log"; then
  printf '\r\033[K\033[31mmmdc could not render the diagram:\033[0m\n\n'

  # The error repeats the diagram text. Remove the color codes of `mmdc`, then
  # all control bytes. Thus the text cannot send escape sequences.
  grep -Ev '\((file|https?)://' "$error_log" |
    sed -E $'s/\033\\[[0-9;]*m//g' |
    tr -d '\000-\010\013-\037\177'

  printf '\nPress any key to close.'
  read -rsn1

  exit 1
fi

# Drawing ---------------------------------------------------------------------

draw() {
  local cols lines

  cols=$(tput cols)
  lines=$(tput lines)

  # A screen clear does not remove Kitty images. Delete them first.
  printf '\033_Ga=d,d=A\033\\\033[2J\033[H'

  chafa -f kitty --scale max --align mid,mid --size "${cols}x$((lines - 1))" "$png"

  printf '\033[%d;1H\033[2mq close\033[0m' "$lines"
}

trap draw WINCH

draw

while true; do
  IFS= read -rsn1 key
  read_status=$?

  # A `WINCH` stops `read` with a status above 128. Any other failure is EOF.
  if [ "$read_status" -gt 128 ]; then continue; fi

  if [ "$read_status" -ne 0 ]; then break; fi

  case "$key" in
    q | Q | $'\e' | '') break ;;
  esac
done
