vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  callback = function()
    vim.hl.on_yank({ higroup = 'IncSearch', timeout = 100 })
  end,
})
