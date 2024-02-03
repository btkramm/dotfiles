local keymap = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

-- Leader

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap('', '<Space>', '<Nop>', options)

-- Buffers

keymap('n', '<leader>k', ':%bd|e#|normal`"<CR>', options)

-- Copying & Pasting

keymap('n', '<leader>p', '"+p', options)
keymap('n', '<leader>y', '"+y', options)

keymap('x', '<leader>p', '"+p', options)
keymap('x', '<leader>y', '"+y', options)

-- Fugitive

keymap('n', '<leader>g', ':G<CR>', options)
keymap('n', '<leader>G', ':vertical G<CR>', options)

keymap('n', '<leader>l', ':G lg<CR>', options)
keymap('n', '<leader>L', ':vertical G lg<CR>', options)

vim.cmd([[
  augroup FugitiveToggle
    autocmd!
    autocmd Filetype fugitive nnoremap <buffer> <leader>g <C-w>q
  augroup END
]])

-- Horizontal & Vertical Movement

vim.cmd(':map H ^')
vim.cmd(':vmap H ^')
vim.cmd(':map L g_')
vim.cmd(':vmap L g_')

keymap('n', 'J', 'jzz', options)
keymap('n', 'K', 'kzz', options)

keymap('n', '{', '<C-u>zz', options)
keymap('n', '}', '<C-d>zz', options)

-- Indentation

keymap('v', '<', '<gv', options)
keymap('v', '>', '>gv', options)

-- LSP

keymap('n', 'gd', ':Telescope lsp_definitions<CR>', options)
keymap('n', 'gi', ':Telescope lsp_implementations<CR>', options)
keymap('n', 'gr', ':Telescope lsp_references<CR>', options)

keymap('n', 'gF', ':Telescope diagnostics<CR>', options)
keymap('n', 'gf', ':lua vim.diagnostic.open_float()<CR>', options)

keymap('n', 'gh', ':lua vim.lsp.buf.hover()<CR>', options)

keymap('n', '<leader>rn', ':lua vim.lsp.buf.rename()<CR>', options)

-- Searching

keymap('n', 'N', 'Nzz', options)
keymap('n', 'n', 'nzz', options)

-- Telescope

keymap('n', '<D-o>', ':Telescope buffers<CR>', options)
keymap('n', '<D-p>', ':Telescope find_files<CR>', options)

keymap('n', '<D-S-g>', ':Telescope grep_string<CR>', options)
keymap('n', '<D-g>', ':Telescope live_grep<CR>', options)

keymap('n', '<D-S-b>', ':Telescope git_branches<CR>', options)
keymap('n', '<D-S-c>', ':Telescope git_bcommits<CR>', options)
keymap('n', '<D-S-l>', ':Telescope git_commits<CR>', options)

keymap('n', '<D-S-e>', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', options)
keymap('n', '<D-e>', ':Telescope file_browser<CR>', options)

-- Windows

keymap('n', '<C-h>', '<C-w>h', options)
keymap('n', '<C-j>', '<C-w>j', options)
keymap('n', '<C-k>', '<C-w>k', options)
keymap('n', '<C-l>', '<C-w>l', options)

keymap('n', '<C-n>', ':vertical resize -8<CR>', options)
keymap('n', '<C-s>', ':resize -8<CR>', options)
keymap('n', '<C-t>', ':resize +8<CR>', options)
keymap('n', '<C-w>', ':vertical resize +8<CR>', options)

-- Search

keymap('n', '<ESC>', ':noh<CR>', options)

-- Mark

local mark_path = '~/.local/share/nvim/sessions/mark'

vim.keymap.set('n', '<D-§>', function()
  vim.cmd(string.format('mksession! %s', mark_path))
end, options)

vim.keymap.set('n', '<D-BS>', function()
  if pcall(vim.cmd, string.format('source %s', mark_path)) then
    vim.cmd(string.format('silent !rm %s', mark_path))
  end
end, options)

vim.keymap.set('n', '<D-S-BS>', function()
  vim.cmd(string.format('silent !rm %s', mark_path))
end, options)
