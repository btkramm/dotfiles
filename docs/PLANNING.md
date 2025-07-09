# Diffview.nvim GitHub PR Comments Integration Plan

## Overview

This document outlines the implementation plan for integrating GitHub PR comments with diffview.nvim, enabling users to:
1. View existing PR comments as indicators in the diff view
2. Add positioned comments at the cursor location while reviewing PRs

## Research Findings

### Diff Position Mapping Utilities

#### 1. diffview.nvim Built-in Utilities
- **`parse_diff()`** in `/diffview/vcs/utils.lua`: Parses git diff output into structured data
  - Extracts hunks with `old_row`, `old_size`, `new_row`, `new_size`
  - Handles file metadata (renames, modes, similarity)
  - Can reconstruct file versions with `diff_build_hunk()`
- **Myers' diff algorithm** in `/diffview/diff.lua`: Line-by-line comparison returning edit scripts

#### 2. Neovim Built-in `vim.diff()`
```lua
-- Example usage for position mapping
local indices = vim.diff(old_content, new_content, {result_type = 'indices'})
-- Returns: {{start_a, count_a, start_b, count_b}, ...}
```
- Supports multiple algorithms: myers, minimal, patience, histogram
- Perfect for mapping between file versions

#### 3. octo.nvim Approach
- **`process_patch()`** in `/octo/utils.lua`: Comprehensive patch parsing
- Extracts hunk headers and comment-valid ranges
- Maps `originalLine` to diff positions for thread positioning

### GitHub API Requirements

#### For Reading Comments
```bash
# Get PR-level comments
gh api /repos/{owner}/{repo}/issues/{number}/comments

# Get review comments (positioned)
gh api /repos/{owner}/{repo}/pulls/{number}/comments
```

#### For Creating Positioned Comments
```bash
# Create a review with positioned comments
gh api repos/:owner/:repo/pulls/:number/reviews \
  --method POST \
  --field body="Review comment" \
  --field event="COMMENT" \
  --field comments='[{
    "path": "file.js",
    "position": 5,  # Line in the diff, not file
    "body": "Comment text"
  }]'
```

## Implementation Approach

### Phase 1: Display Existing Comments

#### 1.1 Comment Fetching Module
Create `lua/diffview-github/comments.lua`:
```lua
local M = {}

-- Fetch all PR comments using gh CLI
function M.fetch_pr_comments(pr_number)
  -- Use gh api to get both issue and review comments
  -- Parse and structure the data
  -- Return mapped by file path and line number
end

-- Map comment positions to diff positions
function M.map_comments_to_diff(comments, diff_data)
  -- Use vim.diff() or parse_diff() to create position mappings
  -- Handle both sides of the diff
  -- Return comments with diff_line positions
end

return M
```

#### 1.2 Visual Indicators

**Using Neovim's Display APIs:**

1. **Signs** (for the sign column):
```lua
vim.fn.sign_define("DiffviewGHComment", {
  text = "💬",
  texthl = "DiagnosticInfo"
})
```

2. **Virtual Text** (inline indicators):
```lua
vim.api.nvim_buf_set_extmark(bufnr, ns_id, line - 1, 0, {
  virt_text = {{" [2 comments]", "Comment"}},
  virt_text_pos = "eol",
  priority = 100
})
```

3. **Floating Preview** (on hover):
```lua
-- Show comment content in floating window on cursor hold
```

#### 1.3 Diffview Integration Hooks

```lua
-- Hook into diffview events
local diffview = require("diffview")
local events = require("diffview.events")

-- When diff buffer is loaded
events.on(events.Event.DiffBufRead, function(bufnr, ctx)
  -- Fetch comments for the file
  -- Map to diff positions
  -- Add visual indicators
end)

-- When entering a diff window
events.on(events.Event.DiffBufWinEnter, function(bufnr, winid)
  -- Refresh indicators if needed
  -- Set up keymaps for comment navigation
end)
```

### Phase 2: Create Positioned Comments

#### 2.1 Cursor Position to Diff Position

```lua
function M.get_diff_position_at_cursor()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local bufnr = vim.api.nvim_get_current_buf()
  
  -- Get diff metadata from diffview
  local view = require("diffview.lib").get_current_view()
  local file = view:get_file_for_buf(bufnr)
  
  -- Calculate position in the unified diff
  -- Account for hunk headers and context
  return {
    path = file.path,
    position = calculated_position,
    side = file.symbol == "a" and "LEFT" or "RIGHT"
  }
end
```

#### 2.2 Comment Creation Command

```lua
function M.add_comment_at_cursor()
  local pos = M.get_diff_position_at_cursor()
  
  -- Get comment text (vim.fn.input or floating input)
  local comment_text = vim.fn.input("Comment: ")
  
  -- Create review if needed
  local review_id = M.ensure_review_exists()
  
  -- Add comment using gh api
  local result = vim.fn.system(string.format(
    'gh api repos/:owner/:repo/pulls/%d/reviews -f body="" -f event=COMMENT ' ..
    '-f comments[][path]=%s -f comments[][position]=%d -f comments[][body]="%s"',
    pr_number, pos.path, pos.position, comment_text
  ))
end
```

### Phase 3: Configuration and UX

#### 3.1 Configuration Options

```lua
require("diffview-github").setup({
  -- Display options
  show_signs = true,
  show_virtual_text = true,
  sign_priority = 100,
  
  -- Comment indicators
  comment_sign = "💬",
  resolved_sign = "✓",
  
  -- Keymaps
  keymaps = {
    add_comment = "<leader>gc",
    next_comment = "]c",
    prev_comment = "[c",
    preview_comment = "<leader>gp"
  },
  
  -- Integration
  auto_load_comments = true,
  refresh_on_focus = true
})
```

#### 3.2 User Commands

```vim
:DiffviewGHLoadComments    " Manually load comments
:DiffviewGHAddComment      " Add comment at cursor
:DiffviewGHNextComment     " Navigate to next comment
:DiffviewGHPreviewComment  " Show comment in float
```

## Edge Cases and Considerations

### 1. Position Accuracy
- Comments on deleted lines (only visible on LEFT side)
- Comments on added lines (only visible on RIGHT side)
- Comments spanning multiple lines
- Outdated comments on changed code

### 2. Performance
- Cache fetched comments to avoid repeated API calls
- Use async operations for API requests
- Debounce refresh on buffer changes

### 3. Review Workflow
- Track if user has an open review
- Handle PENDING vs COMMENT events
- Support batch comment submission

### 4. Visual Clarity
- Don't clutter the diff view
- Make indicators clearly distinguishable
- Respect user's colorscheme

## Future Enhancements

1. **Thread Support**: Show full comment threads, not just initial comments
2. **Inline Editing**: Edit/reply to comments directly in Neovim
3. **Suggestion Mode**: Apply GitHub's suggested changes
4. **Review Summary**: Show overall review status and checks
5. **Integration with octo.nvim**: Share comment cache and settings

## Implementation Timeline

1. **Week 1**: Basic comment fetching and display
2. **Week 2**: Position mapping and visual indicators
3. **Week 3**: Comment creation functionality
4. **Week 4**: Polish, configuration, and documentation

## References

- [GitHub REST API - Pull Request Reviews](https://docs.github.com/en/rest/pulls/reviews)
- [Neovim Extmarks Documentation](https://neovim.io/doc/user/api.html#nvim_buf_set_extmark())
- [diffview.nvim Events](https://github.com/sindrets/diffview.nvim/blob/main/lua/diffview/events.lua)
- [octo.nvim Implementation](https://github.com/pwntester/octo.nvim)