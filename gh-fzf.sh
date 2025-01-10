#!/bin/bash

function fetch_prs() {
    local search_query="$1"
    gh pr list --search "$search_query" --json number,author,title,updatedAt,headRepository -R fintual/mobile-app |
        jq -r '.[] | "\(.number)\t\(.headRepository.name)\t\(.updatedAt)\t\(.title)\t\(.author.login)"'
}

# Fetch both authored and review-requested PRs
my_prs=$(fetch_prs "is:open author:@me")
review_prs=$(fetch_prs "is:open review-requested:@me")

# Combine PRs with headers
all_prs=$(printf "📝 My PRs:\n%s\n👀 To Review:\n%s" "$my_prs" "$review_prs")

# Use fzf in a loop with preview window
while true; do
    pr=$(echo "$all_prs" | fzf --header "Enter to open PR, ESC to quit" \
                               --preview-window "right:50%" \
                               --preview 'PR_NUM=$(echo {} | grep -v ":" | cut -f1); if [ ! -z "$PR_NUM" ]; then gh pr view $PR_NUM -R fintual/mobile-app; fi')
    
    if [ -z "$pr" ]; then
        break
    fi

    # Only process if we selected a PR line (not a header)
    if echo "$pr" | grep -q "^[0-9]"; then
        pr_number=$(echo "$pr" | cut -f1)
        kitty @ launch --copy-env --type=tab --tab-title="$pr_number" --cwd="~/work/mobile-app/main" nvim -c ":Octo pr edit $pr_number"
    fi
done
