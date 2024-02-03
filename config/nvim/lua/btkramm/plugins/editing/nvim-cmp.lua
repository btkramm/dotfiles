return {
  'hrsh7th/nvim-cmp',
  dependencies = { 'hrsh7th/cmp-nvim-lsp' },

  config = function()
    local cmp = require('cmp')

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),

        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
      }),

      sources = cmp.config.sources({
        { name = 'luasnip', group_index = 0, max_item_count = 5 },
        { name = 'nvim_lsp', group_index = 1, max_item_count = 10 },
        { name = 'buffer', group_index = 2, max_item_count = 10 },
      }),

      completion = { completeopt = 'menu,menuone,noinsert' },
    })

    local cmp_autopairs = require('nvim-autopairs.completion.cmp')

    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}
