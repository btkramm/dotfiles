return {
  'ibhagwan/fzf-lua',

  config = function()
    local fzf = require('fzf-lua')

    fzf.setup({
      { 'ivy' },

      defaults = {
        file_icons = false,
        git_icons = false,

        no_header = true,
        no_header_i = true,
      },

      keymap = {
        builtin = {
          true,

          ['<C-d>'] = 'preview-page-down',
          ['<C-u>'] = 'preview-page-up',
        },
        fzf = {
          true,

          ['ctrl-d'] = 'preview-page-down',
          ['ctrl-u'] = 'preview-page-up',

          ['ctrl-q'] = 'select-all+accept',
        },
      },

      actions = {
        files = {
          ['enter'] = fzf.actions.file_edit_or_qf,

          ['ctrl-v'] = fzf.actions.file_vsplit,
          ['ctrl-x'] = fzf.actions.file_split,

          ['alt-q'] = fzf.actions.file_sel_to_qf,

          ['alt-.'] = fzf.actions.toggle_hidden,
          ['alt-f'] = fzf.actions.toggle_follow,
          ['alt-i'] = fzf.actions.toggle_ignore,
        },
      },

      files = {
        cwd_prompt = false,

        hidden = false,
        follow = false,
        no_ignore = false,
      },

      git = {
        branches = { cmd = 'git branch --color' },
      },

      grep = {
        rg_glob = true,
        rg_glob_fn = function(value, _)
          local pattern, options = value:match('(.-)%s%-%-(.*)')

          return pattern, options
        end,
      },

      buffers = {
        keymap = {
          builtin = { ['<C-d>'] = false },
        },
        actions = {
          ['ctrl-x'] = false,
          ['ctrl-d'] = { fzf.actions.buf_del, fzf.actions.resume },
        },
      },
    })
  end,

  keys = {
    {
      '<D-o>',
      function()
        require('fzf-lua').buffers({
          winopts = { title = 'Open Files' },
        })
      end,
      desc = 'fzf - Open Files',
    },
    {
      '<D-p>',
      function()
        require('fzf-lua').files({
          winopts = { title = 'Files' },
        })
      end,
      desc = 'fzf - Files',
    },

    {
      '<D-S-g>',
      function()
        require('fzf-lua').grep_cword({
          winopts = { title = 'Grep' },
        })
      end,
      desc = 'fzf - Grep - Word under cursor',
    },
    {
      '<D-S-g>',
      function()
        require('fzf-lua').grep_visual({
          winopts = { title = 'Grep' },
        })
      end,
      mode = 'v',
      desc = 'fzf - Grep - Visual selection',
    },
    {
      '<D-g>',
      function()
        require('fzf-lua').live_grep({
          winopts = { title = 'Grep' },
        })
      end,
      desc = 'fzf - Live Grep',
    },

    {
      '<D-S-c>',
      function()
        require('fzf-lua').git_bcommits({
          winopts = { title = 'Buffer Git Commits' },
        })
      end,
      desc = 'fzf - Buffer Git Commits',
    },
    {
      '<D-b>',
      function()
        require('fzf-lua').git_branches({
          winopts = { title = 'Git Branches' },
        })
      end,
      desc = 'fzf - Git Branches',
    },
    {
      '<D-l>',
      function()
        require('fzf-lua').git_commits({
          winopts = { title = 'Git Commits' },
        })
      end,
      desc = 'fzf - Git Commits',
    },

    {
      '<D-f>',
      function()
        require('fzf-lua').diagnostics_workspace({
          winopts = { title = 'LSP Diagnostics' },
        })
      end,
      desc = 'fzf - LSP Diagnostics',
    },
    {
      'gd',
      function()
        require('fzf-lua').lsp_definitions({
          winopts = { title = 'LSP Definitions' },
        })
      end,
      desc = 'fzf - LSP Definitions',
    },
    {
      'gi',
      function()
        require('fzf-lua').lsp_implementations({
          winopts = { title = 'LSP Implementations' },
        })
      end,
      desc = 'fzf - LSP Implementations',
    },
    {
      'gr',
      function()
        require('fzf-lua').lsp_references({
          winopts = { title = 'LSP References' },
        })
      end,
      desc = 'fzf - LSP References',
    },
  },
}
