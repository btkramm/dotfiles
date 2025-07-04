session_name=$(abduco | fzf | awk '{print $NF}')

abduco -a "$session_name"
