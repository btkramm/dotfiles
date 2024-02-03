pwr() {
  realpath "$(git rev-parse --git-common-dir 2> /dev/null)" 2> /dev/null
}
