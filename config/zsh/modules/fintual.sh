PUPPETEER_EXECUTABLE_PATH=$(which chromium)

export PUPPETEER_EXECUTABLE_PATH
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

export RUBY_CFLAGS="-Wno-error=implicit-function-declaration"

if command -v "rbenv" &> /dev/null; then
  eval "$(rbenv init -)"
fi
