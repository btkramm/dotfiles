result=$(zoxide query "$@")

cd "$result" || exit

session_name=$(pwd | tr '/' '-' | sed 's/^-//' | tr '[:upper:]' '[:lower:]')

abduco -A "$session_name" nvim
