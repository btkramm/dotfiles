#!/bin/bash

prs_json=$(gh pr list --search "is:open author:@me" --json number,author,title,updatedAt,headRepository) 

prs=$(echo "$prs_json" | jq -r '.[] | "\(.number)\t\(.headRepository.name)\t\(.updatedAt)\t\(.title)\t\(.author.login)"')

pr=$(echo "$prs" | fzf)

pr_number=$(echo "$pr" | cut -f1)

kitty @ launch --copy-env --type=tab --tab-title="$pr_number" --cwd="~/work/mobile-app/main" nvim -c ":Octo pr edit $pr_number"
